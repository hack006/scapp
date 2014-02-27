# Sport coach app - (ScApp)
Web based, _Ruby on Rails_ driven, application for creating and managing people and sport trainings especially
designed for sport clubs and gyms.

## Usage
Application can be used for a lot of basic stuff done inside sport club

* organization of members
    * a lot of roles for granting permissions
        * **admin**
        * **coach**
        * **player**
        * **parents**, **sponsor**
    * connections between players supported ( **player** <-- _trained-by_ --> **coach** )
    * organization into groups
* registering and visualisation of **player** efficiency
    * simple statistics (best value, worst value, trend based on _linear regression line_)
    * **configurable chart**
* creating **individual training plans**
    * division into parts supported
        * **macrocycle**
        * **mezocycle**
        * **microcycle**
        * each part can have own _specification of goals_
* detailed training lesson planning
    * creating by inserting excercises from database and configuring params (example: you insert _bench press_ and
    configure _weight_, _repetitions_, _speed_ and _pause_)
    * training lessons can be reused
    * output training lesson with time schedule

## About
This application has been created as final Bachelor's thesis on CTU in Prague.

## Installation
TODO

## Contributing
TODO

## Thanks
I would like to thank my supervisor Ing. Ondřej Macek for leading this work.

## License
This work is distributed under GPLv3.


