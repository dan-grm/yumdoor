{{flutter_js}}
{{flutter_build_config}}

// No serviceWorkerSettings: Flutter's own service worker is deprecated. We
// register web/service_worker.js instead; the relative URL resolves against
// <base href>, so its scope is the base path.
// Passing `preferWebParagraph` would need the canvaskit/webparagraph/ files
// that tool/finish_web_build.dart removes.
_flutter.loader.load();

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('service_worker.js').catch((error) => {
    console.warn('Service worker registration failed:', error);
  });
  // Files loaded before the worker was in control (the first visit), e.g. the
  // CanvasKit variant this browser uses, are handed to it for offline start.
  window.addEventListener(
    'flutter-first-frame',
    async () => {
      const registration = await navigator.serviceWorker.ready;
      registration.active?.postMessage({
        type: 'loaded',
        urls: performance.getEntriesByType('resource').map((entry) => entry.name),
      });
    },
    { once: true }
  );
}
