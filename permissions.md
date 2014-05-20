# User

| ID    | Action                        | implemented?  | owner     | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :watcher  | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | --------- | ----- |
| 1.1   | Create _user_                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | -         | Y         |
| 1.2   | Show _user_ dashboard         | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | -         | -         |
| 1.3   | Show detail                   | Y             | Y         | Y         | Y         | Y         | Y             | -         | -         | -         | -         | Y         |
| 1.4   | Edit _user_ profile           | Y             | Y         | -         | -         | -         | -             | -         | -         | -         | -         | Y         |
| 1.5   | Delete _user_                 | Y             | -         | -         | -         | -         | -             | -         | -         | -         | -         | -         |
| 1.6   | Add _user_ role               | Y             | -         | -         | -         | -         | -             | -         | -         | -         | -         | Y         |
| 1.7   | Remove _user_ role            | Y             | -         | -         | -         | -         | -             | -         | -         | -         | -         | Y         |
| 1.8   | List users                    | Y             | -         | -         | -         | -         | -             | -         | Y         | Y         | Y         | Y         |

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

# Variable field categories

| ID    | Action                        | implemented?  | is_global? | owner    | friend[R] | coach[R]  | player[R] | watcher[R]| :watcher  | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | ---------- | -------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | ----- |
| 15.1  | List VF categories            | Y             | -          | -        | -         | -         | -         | -         | Y (*1)    | Y (*1)    | Y (*1)    | Y         | *1 - Can see only owned or global entries
| 15.2  | Show VF category              | Y             | Y          | Y        | Y         | Y         | Y         | Y         | -         | -         | -         | -         |
| 15.3  | Create VF category            | Y             | -          | -        | -         | -         | -         | -         | -         | Y         | Y         | Y         |
| 15.4  | Edit VF category              | Y             | -          | Y        | -         | -         | -         | -         | -         | -         | -         | Y         |
| 15.5  | Delete VF category            | Y             | -          | Y        | -         | -         | -         | -         | -         | -         | -         | Y         |


# Variable field measurements

| ID    | Action                        | implemented?  | owner     | training_owner [R]    | training_coach[R] | training_player[R]    | suplementation    | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | --------------------- | ----------------- | --------------------- |------------------ | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 5.1   | Add measurement               | Y             | -         | -                     | -                 | -                     | -                 | -         | (*1)      | -         | -             | -         | (2*)      | -         | Y         | *1,2 - only if VF global || owned by user
| 5.2   | Edit measurement              | Y             | Y         | -                     | -                 | -                     | -                 | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.3   | Delete measurement            | Y             | Y         | -                     | -                 | -                     | -                 | -         | (*1)      | -         | -             | -         | -         | -         | Y         | *1 - only if measured_by == current_user
| 5.4   | Show detail                   | Y             | Y (*1)    | -                     | -                 | -                     | -                 | -         | Y         | -         | -             | -         | -         | -         | Y         | *1 - owner = measured_by, (measured_for - discuss??)
| 5.5   | List                          | Y             | -         | -                     | -                 | -                     | -                 | -         | -         | -         | -             | -         | Y (*1)    | Y (2*)    | Y         | *1 - can see only own, *2 - can only see own and measurements of his :players
| 5.6   | Add VF training measurements  | -             | -         | Y                     | Y                 | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only own measurement and measurements of :friends
| 5.7   | List VF training measurements | -             | -         | Y                     | Y                 | Y (*1)                | Y                 | Y (*2)    | Y (*3)    | -         | Y (*4)        | -         | -         | -         | Y         | *1 - only own measurements, *2 - see only friend user, *3 - see only coached user, *4 - *2 - see only watched user

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
| 7.7   | Show player attendance        | Y             | Y         | Y                     | -                     | Y             | -         | -         | -         | Y         |

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

# Training lesson realization

* **owner** - user owning regular training

| ID    | Action                        | implemented?  | owner     | training_coach[R] | training_player[R]    | suplementation    | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ----------------------------- | ------------- | --------- | ----------------- | --------------------- | ----------------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 11.1  | List scheduled lessons        | ?             | Y         | Y                 | Y                     | -                 | -         | -         | -         | Y *1          | -         | -         | -         | Y         | *1 - only watchers of training players
| 11.2  | Show scheduled lesson         | Y             | Y         | Y                 | Y                     | -                 | -         | -         | -         | Y *1          | -         | Y *2      | -         | Y         | *1 - only watchers of training players, *2 - training public or with open signing
| 11.3  | Create scheduled individual l.| Y             |           | -                 | -                     | -                 | -         | -         | -         | -             | -         | -         | Y         | Y         |
| 11.4  | Edit scheduled lesson         | Y             | Y         | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 11.5  | Delete scheduled lesson       | Y             | Y         | Y *1              | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 11.6  | Close scheduled lesson        | Y             | Y         | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 11.7  | Cancel scheduled lesson       | Y             | Y         | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 11.8  | Reopen scheduled lesson       | Y             | Y         | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 11.9  | Sign in                       | Y             |           | -                 | Y                     | -                 | -         | -         | -         | Y *1          | -         | - *2      | -         | -         | *1 - only watcher of signing in player, *2 - only for public trainings
| 11.10 | Excuse                        | Y             |           | -                 | Y                     | -                 | -         | -         | -         | Y *1          | -         | - *2      | -         | -         | *1 - only watcher of signing in player, *2 - only for public trainings

# Attendance

| ID    | Action                                | implemented?  | owner     | training_owner [R]    | training_coach[R] | training_player[R]    | suplementation    | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ------------------------------------- | ------------- | --------- | --------------------- | ----------------- | --------------------- | ----------------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 12.1  | List scheduled lesson attendances     | Y             | -         | Y                     | Y                 | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         |
| 12.2  | List sched. lesson player attendance  | Y             | -         | Y                     | Y                 | Y *1                  | -                 | -         | -         | -         | Y             | -         | -         | -         | Y         | *1 - only own
| 12.3  | Show attendance                       | Y             | Y         | Y                     | Y                 | Y *1                  | -                 | -         | -         | -         | Y *2          | -         | -         | -         | Y         | *1 - only own, *2 - watcher of player attendance
| 12.4  | Create attendance                     | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 12.5  | Edit attendance                       | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 12.6  | Delete attendance                     | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 12.7  | Fill scheduled lesson attendance      | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 12.8  | Calc scheduled lesson payment         | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach

# Present coaches

| ID    | Action                                | implemented?  | owner     | training_owner [R]    | training_coach[R] | training_player[R]    | suplementation    | friend[R] | coach[R]  | player[R] | watcher[R]    | :guest    | :player   | :coach    | :admin    | note  |
| ----- | ------------------------------------- | ------------- | --------- | --------------------- | ----------------- | --------------------- | ----------------- | --------- | --------- | --------- |-------------- | --------- | --------- | --------- | --------- | ----- |
| 13.1  | List present coaches                  | Y             | -         | Y                     | Y *1              | -                     | Y                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 13.2  | Show present coaches                  | Y             | Y         | Y                     | Y *1              | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 13.3  | Add present coach                     | Y             | -         | Y                     | Y *1              | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 13.4  | Edit present coach                    | Y             | -         | Y                     | Y *1              | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach
| 13.5  | Remove present coach                  | Y             | -         | Y                     | Y *1              | -                     | -                 | -         | -         | -         | -             | -         | -         | -         | Y         | *1 - only head_coach

# Help

| ID    | Action                            | implemented?  | :player   | :coach    | :admin    | note  |
| ----- | --------------------------------- | ------------- | ----------| --------- | --------- | ----- |
| 14.1  | List help themes in spec. locale  | Y             | Y         | Y         | Y         |
| 14.2  | Show help                         | Y             | Y         | Y         | Y         |
| 14.3  | Show modal help                   | Y             | Y         | Y         | Y         |