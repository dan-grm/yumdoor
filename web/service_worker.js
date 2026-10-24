// Yumdoor's service worker: keeps the app shell available for offline start.
// Flutter's generated service worker is deprecated, so flutter_bootstrap.js
// registers this one instead (docs/ARCHITECTURE.md#server-url-and-deployment).
//
// - Only files of the build and navigations under the scope are handled. API
//   requests, media and everything else of Tandoor go to the network untouched;
//   offline data lives in Drift, not here.
// - Network first, cache as fallback: online, the browser revalidates with the
//   server (nginx sends `no-cache` and ETags), so a new deploy is used at once.
// - The precache holds every file of the build except the CanvasKit variants;
//   the page reports the variant it loaded, and that one is cached as well.
//
// BUILD and FILES are filled in by tool/finish_web_build.dart after
// `flutter build web`. Unstamped (e.g. `flutter run`), the worker does nothing.

'use strict';

const BUILD = null;
const FILES = null;

const CACHE_PREFIX = 'yumdoor-shell-';
const CACHE = CACHE_PREFIX + BUILD;
const SCOPE = new URL(self.registration.scope);
// The scope URL itself (the base path) is the app's index.html.
const INDEX = SCOPE.href;

/** Absolute URL of a file path relative to the scope ('' is index.html). */
const fileUrl = (path) => new URL(path, SCOPE).href;

const shell = new Set((FILES ?? []).map(fileUrl));
const precache = (FILES ?? [])
  .filter((path) => !path.startsWith('canvaskit/'))
  .map(fileUrl);

self.addEventListener('install', (event) => {
  if (BUILD === null) return;
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE);
      // `no-cache` revalidates, so files the page just loaded cost a 304.
      await cache.addAll(
        precache.map((url) => new Request(url, { cache: 'no-cache' }))
      );
      await self.skipWaiting();
    })()
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      for (const name of await caches.keys()) {
        if (name.startsWith(CACHE_PREFIX) && name !== CACHE) {
          await caches.delete(name);
        }
      }
      await self.clients.claim();
    })()
  );
});

self.addEventListener('fetch', (event) => {
  if (BUILD === null) return;
  const request = event.request;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  url.search = '';
  url.hash = '';
  if (request.mode === 'navigate') {
    if (url.origin !== SCOPE.origin || !url.pathname.startsWith(SCOPE.pathname)) {
      return;
    }
    // Every route of the app is answered with index.html (nginx SPA fallback).
    event.respondWith(networkFirst(event, request, INDEX));
  } else if (shell.has(url.href)) {
    event.respondWith(networkFirst(event, request, url.href));
  }
});

// Sent by flutter_bootstrap.js after the first frame with the URLs the page
// loaded, which on the first visit happened before this worker was in control.
self.addEventListener('message', (event) => {
  if (BUILD === null || event.data?.type !== 'loaded') return;
  event.waitUntil(cacheLoaded(event.data.urls));
});

async function networkFirst(event, request, key) {
  const cache = await caches.open(CACHE);
  try {
    const response = await fetch(request);
    if (isCacheable(response, key)) {
      event.waitUntil(cache.put(key, response.clone()));
    }
    return response;
  } catch (error) {
    const cached = await cache.match(key);
    if (cached) return cached;
    throw error;
  }
}

function isCacheable(response, key) {
  if (!response.ok || response.type !== 'basic') return false;
  // A navigation that reached something other than the app (e.g. a proxy's
  // error page) must not replace the cached index.html.
  return key !== INDEX || isHtml(response);
}

const isHtml = (response) =>
  (response.headers.get('content-type') ?? '').startsWith('text/html');

async function cacheLoaded(urls) {
  if (!Array.isArray(urls)) return;
  const cache = await caches.open(CACHE);
  for (const loaded of urls) {
    let url;
    try {
      url = new URL(loaded);
    } catch {
      continue;
    }
    url.search = '';
    url.hash = '';
    if (!shell.has(url.href) || (await cache.match(url.href))) continue;
    try {
      await cache.add(new Request(url.href, { cache: 'no-cache' }));
    } catch {
      // Offline or gone with a new deploy; the next visit tries again.
    }
  }
}
