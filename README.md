# mapperapp

# Task & Plan Manager App  

## License  
This project is licensed under the MIT License © 2025 (https://github.com/MariamAshraf200).  

---

## A Flutter project is mainly used for  
* **Task Feature:**  
  * Add, update, and delete tasks.  
  * Mark tasks as completed or not completed.  
  * Organize and track tasks with simple daily management.  

* **Plan Feature:**  
  * Create plans that contain a group of tasks.  
  * Add subtasks, update their status, or remove them.  
  * Automatically track progress of plans based on tasks’ completion.  
  * Store plans locally using **Hive** for persistence.  

---

# The main Technologies & Packages/Plugins used in the App  
* **State Management:** Using [flutter_bloc](https://pub.dev/packages/flutter_bloc).  
* **Local Database:** [hive](https://pub.dev/packages/hive).  
* **Dependency Injection:** [get_it](https://pub.dev/packages/get_it).  
* **Architecture:** Clean Architecture following **Uncle Bob** principles.  
* **Other Plugins:**  
  * [uuid](https://pub.dev/packages/uuid) – for unique IDs.  
  * [intl](https://pub.dev/packages/intl) – for date formatting.  

---

# The App Architecture, Directory structure, And State Management  
* Using `Bloc` for State Management.  
* Using `get_it` for Dependency injection.  
* Applying `Clean Architecture` layered design.  

📌 Example Clean Architecture model used:  
![image](link-to-your-model-image)  

## Directory Structure  

lib
│───main.dart
│───l10n/
│
└───src
│───core
│ ├──error/
│ ├──util/
│ └──widgets/
│
│───features
│ ├──tasks/
│ │ ├──data/
│ │ ├──domain/
│ │ └──presentation/
│ │
│ └──plans/
│ ├──data/
│ ├──domain/
│ └──presentation/
│
│───app.dart
└───injection_container.dart 


---

# App pages  

## Tasks Screens  
  Add & Manage Tasks              | Mark Tasks Complete  
:-------------------------:|:-------------------------:  
![](link-to-screenshot) | ![](link-to-screenshot)  

## Plan Screens  
  Create Plan with Subtasks       | Track Plan Progress  
:-------------------------:|:-------------------------:  
![](link-to-screenshot) | ![](link-to-screenshot)  

