# User

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 1.1   | Create _user_                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.2   | Show _user_ dashboard         | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |
| 1.3   | Show detail                   | -             | Y         | Y         | Y         | Y         | Y             | -         | -         | -         | Y         |
| 1.4   | Edit _user_ profile           | -             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.5   | Delete _user_                 | -             | -         | -         | -         | -         | -             | -         | -         | -         | -         |
| 1.6   | Add _user_ role               | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.7   | Remove _user_ role            | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 1.8   | List users                    | -             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |

# User groups

- **[V]**   - visibility of user group
- **[R]**   - relation is get to group owner

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 2.1   | List _user groups_            | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 2.2   | Show detail                   | Y             | Y         | -         | -         | -         | -             | [V]=public| (*1)      | (*2)      | Y         | *1,2 - [V] != owner && if [V] == members => I am member
| 2.3   | View user groups              | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 2.4   | Create _user group_           | Y             | -         | -         | -         | -         | -             | -         | -         | Y         | Y         |
| 2.5   | Edit _user group_             | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 2.6   | Delete _user group_           | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 2.7   | Add user to group             | Y             | Y*        | -         | -         | -         | -             | -         | -         | -         | Y         | user can only add users with existing relation to him, :admin can all
| 2.8   | Remove user from group        | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |

# User relations

- **owner**     - one of relation sides

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 3.1   | List user relations           | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 3.2   | Create confirmed relation     | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 3.3   | Request relation              | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 3.4   | Change my relation status     | Y             | Y (*1)    | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - must be on one relation end
| 3.5   | List relations                | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |

# Variable fields


| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 4.1   | List [own + global]           | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 4.2   | Show detail [own + global]    | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         | Not for :player because sensitible information are present
| 4.3   | View user _variable fields_   | Y             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 4.4   | View user _VF detail_         | -             | Y         | -         | Y         | -         | Y             | -         | -         | -         | Y         |
| 4.5   | Create [global]               | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.6   | Create [own]                  | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 4.7   | Edit [global]                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.8   | Edit [own]                    | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.9   | Delete [global]               | Y             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 4.10  | Delete [own]                  | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | Y         |

# Variable field measurements

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 5.1   | Add measurement               | Y             | -         | -         | (*1)      | -         | -             | -         | (2*)      | -         | Y         | *1,2 - only if VF global || owned by user
| 5.2   | Edit measurement              | Y             | Y         | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.3   | Delete measurement            | Y             | Y         | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.4   | Show detail                   | Y             | Y (*1)    | -         | Y         | -         | -             | -         | -         | -         | Y         | *1 - owner = measured_by, (measured_for - discuss??)
| 5.5   | List                          | Y             | -         | -         | -         | -         | -             | -         | Y (*1)    | Y (2*)    | Y         | *1 - can see only own, *2 - can only see own and measurements of his :players

# Organization

**Is postponed to next release.**

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 6.1   | List organizations            | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 6.2   | Show detail                   | -             | Y         | -         | -         | -         | -             | -         | Y         | Y         | Y         |
| 6.3   | Show public profile           | -             | -         | -         | -         | -         | -             | Y         | Y         | Y         | Y         |
| 6.4   | Create _organization_         | -             | -         | -         | -         | -         | -             | -         | -         | -         | Y         |
| 6.5   | Edit _organization_           | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |
| 6.6   | Delete _organization_         | -             | Y         | -         | -         | -         | -             | -         | -         | -         | -         |

# Regular training

**watcher[R]** is tested against _owner_, _training players_ and _training coaches_

| ID    | Action                        | implemented?  | owner     | training_coach[R]     | training_player[R]    | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------------------- | --------------------- | ------------- | --------- | --------- | --------- | --------- | ----- |
| 7.1   | List trainings                | Y             | -         | -                     | -                     | -             | -         | -         | Y *       | Y         | * - view only owned trainings
| 7.2   | Show training detail          | Y             | Y         | Y                     | Y                     | Y             | -         | -         | -         | Y         |
| 7.3   | Show public training detail   | -             | -         | -                     | -                     | -             | Y         | Y         | Y         | Y         |
| 7.4   | Create training               | Y             | -         | -                     | -                     | -             | -         | -         | Y         | Y         |
| 7.5   | Edit training                 | Y             | Y         | -                     | -                     | -             | -         | -         | -         | Y         |
| 7.6   | Delete training               | Y             | Y         | -                     | -                     | -             | -         | -         | -         | Y         |
| 7.7   | Show player attendance        | -             | Y         | Y                     | -                     | Y             | -         | -         | -         | Y         |

# Training lesson

**owner** is get from wrapping regular training

| ID    | Action                        | implemented?  | owner     | training_coach[R] | training_player[R]    | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | ----------------- | --------------------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 8.1   | List training lessons         | Y             | Y         | Y                 | Y                     | -         | -         | -         | Y (*1)        | -         | -         | -         | Y         | *1 - see regular training
| 8.2   | Show training lesson detail   | Y             | Y         | Y (1*)            | Y (2*)                | -         | -         | -         | Y (*2)        | -         | -         | -         | Y         | *1 - view _finance_ only if :head_coach, *2 - do not view _finance_
| 8.3   | Create training lesson        | Y             | Y         | -                 | -                     | -         | -         | -         | -             | -         | -         | -         | Y         |
| 8.4   | Edit training lesson          | Y             | Y         | -                 | -                     | -         | -         | -         | -             | -         | -         | -         | Y         |
| 8.5   | Delete training lesson        | Y             | Y         | -                 | -                     | -         | -         | -         | -             | -         | -         | -         | Y         |

#  VAT

| ID    | Action                        | implemented?  | owner     | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- | --------- | ----- |
| 9.1   | List VATs                     | Y             | -         | -         | -         | -         | Y         |
| 9.2   | Create VAT                    | Y             | -         | -         | -         | -         | Y         |
| 9.3   | Edit VAT                      | Y             | -         | -         | -         | -         | Y         |
| 9.4   | Delete VAT                    | Y             | -         | -         | -         | -         | Y         |

#  Currency

| ID    | Action                        | implemented?  | owner     | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- | --------- | ----- |
| 9.1   | List currencies               | Y             | -         | -         | -         | -         | Y         |
| 9.2   | Create currency               | Y             | -         | -         | -         | -         | Y         |
| 9.3   | Edit currency                 | Y             | -         | -         | -         | -         | Y         |
| 9.4   | Delete currency               | Y             | -         | -         | -         | -         | Y         |

# Coach obligation

* **obligation_coach** - user for whom obligation belongs
* **regular_training_owner** - owner of regular training to which obligation belongs

| ID    | Action                        | implemented?  | obligation_coach  | regular_training_owner    | :admin    | note  |
| ----- | ----------------------------- | ------------- | ----------------- | ----------------------    | --------- | ----- |
| 10.1  | Show obligation               | Y             | Y                 | Y                         | Y         |
| 10.2  | Create obligation             | Y             | -                 | Y                         | Y         |
| 10.3  | Edit obligation               | Y             | -                 | Y                         | Y         |
| 10.4  | Delete obligation             | Y             | -                 | Y                         | Y         |
