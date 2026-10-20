# Bootstrap for tool/seed.dart: creates what the Tandoor API can't for a fresh
# instance. Runs inside the web_recipes container via `manage.py shell`;
# seed.dart prepends a line that defines ARGS (a dict, see seed.dart).
#
# Prints one line `YUMDOOR_SEED_RESULT <json>` with the users, their tokens and
# a few counts of the seeded space, so seed.dart can tell whether it already ran.

import json
import uuid

from django.contrib.auth.models import Group, User
from django.utils import timezone
from django_scopes import scopes_disabled
from oauth2_provider.models import AccessToken

from cookbook.models import CookLog, Household, Recipe, ShoppingListEntry, Space, UserSpace

# Fixed per user so the credentials survive a reset. Dev only.
TOKEN_NAMESPACE = uuid.UUID('8f6a1c2e-5b7d-4e3f-9a0b-1c2d3e4f5a6b')

with scopes_disabled():
    usernames = [u['username'] for u in ARGS['users']]

    if ARGS['reset']:
        for space in Space.objects.filter(name=ARGS['space']):
            space.safe_delete()
        User.objects.filter(username__in=usernames).delete()

    users = {}
    for spec in ARGS['users']:
        user, _ = User.objects.get_or_create(username=spec['username'])
        user.first_name = spec['first_name']
        user.email = spec['email']
        user.is_superuser = user.is_staff = spec['role'] == 'admin'
        user.set_password(spec['password'])
        user.save()
        users[spec['username']] = (user, spec)

    owner = next(user for user, spec in users.values() if spec['role'] == 'admin')
    space = Space.objects.filter(name=ARGS['space']).first()
    if space is None:
        space = Space.objects.create(name=ARGS['space'], created_by=owner,
                                     space_setup_completed=True, household_setup_completed=True)
    household, _ = Household.objects.get_or_create(space=space, name=ARGS['household'])

    result_users = []
    for user, spec in users.values():
        user_space, _ = UserSpace.objects.get_or_create(user=user, space=space)
        user_space.household = household if spec['household'] else None
        user_space.active = True
        user_space.save()
        user_space.groups.set([Group.objects.get(name=spec['role'])])
        UserSpace.objects.filter(user=user).exclude(pk=user_space.pk).update(active=False)

        token_value = 'tda_' + str(uuid.uuid5(TOKEN_NAMESPACE, user.username)).replace('-', '_')
        token, _ = AccessToken.objects.update_or_create(
            token=token_value,
            defaults={'user': user, 'scope': 'read write',
                      'expires': timezone.now() + timezone.timedelta(days=365 * 5)},
        )
        result_users.append({
            'username': user.username,
            'password': spec['password'],
            'user_id': user.pk,
            'role': spec['role'],
            'household': spec['household'],
            'token': token.token,
        })

    result = {
        'space_id': space.pk,
        'household_id': household.pk,
        'users': result_users,
        'counts': {
            'recipes': Recipe.objects.filter(space=space).count(),
            'cook_logs': CookLog.objects.filter(space=space).count(),
            'shopping_entries': ShoppingListEntry.objects.filter(space=space).count(),
        },
    }
    print('YUMDOOR_SEED_RESULT ' + json.dumps(result))
