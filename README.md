# Lego: Set Checklist Creator

## Information about this repository

### List of Software Files

Program
└─ LegoSetCheckList
├─ bin
│  ├─ default
│  ├─ main
│  │  ├─ lego
│  │  │  └─ checklist
│  │  │     ├─ controller
│  │  │     │  ├─ DatabaseController$1.class
│  │  │     │  ├─ DatabaseController$2.class
│  │  │     │  ├─ DatabaseController$3.class
│  │  │     │  ├─ DatabaseController$4.class
│  │  │     │  ├─ DatabaseController$5.class
│  │  │     │  ├─ DatabaseController$6.class
│  │  │     │  ├─ DatabaseController$7.class
│  │  │     │  ├─ DatabaseController.class
│  │  │     │  ├─ MainController$1.class
│  │  │     │  ├─ MainController.class
│  │  │     │  ├─ PieceController$1.class
│  │  │     │  ├─ PieceController.class
│  │  │     │  ├─ PieceTypeController.class
│  │  │     │  ├─ SetController$1.class
│  │  │     │  ├─ SetController.class
│  │  │     │  ├─ ThemeController$1.class
│  │  │     │  └─ ThemeController.class
│  │  │     ├─ domain
│  │  │     │  ├─ Account.class
│  │  │     │  ├─ Piece.class
│  │  │     │  ├─ PieceFound.class
│  │  │     │  ├─ Set.class
│  │  │     │  ├─ SetInProgress.class
│  │  │     │  ├─ SetInSetList.class
│  │  │     │  ├─ Set_list.class
│  │  │     │  └─ Theme.class
│  │  │     ├─ repository
│  │  │     │  ├─ AccountRepository.class
│  │  │     │  ├─ PieceFoundRepository.class
│  │  │     │  ├─ SetInfoRepository.class
│  │  │     │  ├─ SetInProgressRepository.class
│  │  │     │  ├─ SetInSetListRepository.class
│  │  │     │  └─ Set_listRepository.class
│  │  │     ├─ validator
│  │  │     │  └─ AccountValidator.class
│  │  │     └─ LegoSetCheckListApplication.class
│  │  ├─ templates
│  │  └─ application.properties
│  └─ test
│     └─ lego
│        └─ checklist
│           └─ LegoSetCheckListApplicationTests.class
├─ build
│  ├─ classes
│  │  └─ java
│  │     └─ main
│  │        └─ lego
│  │           └─ checklist
│  │              ├─ controller
│  │              │  ├─ DatabaseController$1.class
│  │              │  ├─ DatabaseController$2.class
│  │              │  ├─ DatabaseController$3.class
│  │              │  ├─ DatabaseController$4.class
│  │              │  ├─ DatabaseController$5.class
│  │              │  ├─ DatabaseController$6.class
│  │              │  ├─ DatabaseController$7.class
│  │              │  ├─ DatabaseController.class
│  │              │  ├─ MainController$1.class
│  │              │  ├─ MainController.class
│  │              │  ├─ PieceController$1.class
│  │              │  ├─ PieceController.class
│  │              │  ├─ PieceTypeController.class
│  │              │  ├─ SetController$1.class
│  │              │  ├─ SetController.class
│  │              │  ├─ ThemeController$1.class
│  │              │  └─ ThemeController.class
│  │              ├─ domain
│  │              │  ├─ Account.class
│  │              │  ├─ Piece.class
│  │              │  ├─ PieceFound.class
│  │              │  ├─ Set.class
│  │              │  ├─ SetInProgress.class
│  │              │  ├─ SetInSetList.class
│  │              │  ├─ Set_list.class
│  │              │  └─ Theme.class
│  │              ├─ repository
│  │              │  ├─ AccountRepository.class
│  │              │  ├─ PieceFoundRepository.class
│  │              │  ├─ SetInfoRepository.class
│  │              │  ├─ SetInProgressRepository.class
│  │              │  ├─ SetInSetListRepository.class
│  │              │  └─ Set_listRepository.class
│  │              ├─ validator
│  │              │  └─ AccountValidator.class
│  │              └─ LegoSetCheckListApplication.class
│  ├─ generated
│  │  └─ sources
│  │     ├─ annotationProcessor
│  │     │  └─ java
│  │     │     └─ main
│  │     └─ headers
│  │        └─ java
│  │           └─ main
│  ├─ libs
│  │  └─ LegoSetCheckList-1.0.0.war
│  ├─ resources
│  │  └─ main
│  │     ├─ static
│  │     ├─ templates
│  │     └─ application.properties
│  ├─ tmp
│  │  ├─ bootWar
│  │  │  └─ MANIFEST.MF
│  │  └─ compileJava
│  │     └─ previous-compilation-data.bin
│  └─ bootWarMainClassName
├─ gradle
│  └─ wrapper
│     ├─ gradle-wrapper.jar
│     └─ gradle-wrapper.properties
├─ src
│  ├─ main
│  │  ├─ java
│  │  │  └─ lego
│  │  │     └─ checklist
│  │  │        ├─ controller
│  │  │        │  ├─ DatabaseController.java
│  │  │        │  ├─ MainController.java
│  │  │        │  ├─ PieceController.java
│  │  │        │  ├─ PieceTypeController.java
│  │  │        │  ├─ SetController.java
│  │  │        │  └─ ThemeController.java
│  │  │        ├─ domain
│  │  │        │  ├─ Account.java
│  │  │        │  ├─ Piece.java
│  │  │        │  ├─ PieceFound.java
│  │  │        │  ├─ Set.java
│  │  │        │  ├─ SetInProgress.java
│  │  │        │  ├─ SetInSetList.java
│  │  │        │  ├─ Set_list.java
│  │  │        │  └─ Theme.java
│  │  │        ├─ repository
│  │  │        │  ├─ AccountRepository.java
│  │  │        │  ├─ PieceFoundRepository.java
│  │  │        │  ├─ SetInfoRepository.java
│  │  │        │  ├─ SetInProgressRepository.java
│  │  │        │  ├─ SetInSetListRepository.java
│  │  │        │  └─ Set_listRepository.java
│  │  │        ├─ validator
│  │  │        │  └─ AccountValidator.java
│  │  │        └─ LegoSetCheckListApplication.java
│  │  ├─ resources
│  │  │  ├─ static
│  │  │  ├─ templates
│  │  │  └─ application.properties
│  │  └─ webapp
│  │     └─ WEB-INF
│  │        └─ views
│  │           ├─ accessDenied.jsp
│  │           ├─ index.jsp
│  │           ├─ profile.jsp
│  │           ├─ search.jsp
│  │           ├─ showPiece_list.jsp
│  │           ├─ showSet.jsp
│  │           ├─ showSetList.jsp
│  │           ├─ showSetLists.jsp
│  │           └─ showSetsInProgress.jsp
│  └─ test
│     └─ java
│        └─ lego
│           └─ checklist
│              └─ LegoSetCheckListApplicationTests.java
├─ build.gradle
├─ gradlew
├─ gradlew.bat
├─ HELP.md
└─ settings.gradle

### Installation of software

*You must have at least Java 8 or JDK 8 to run this software*

1. First start a mysql server and run the following to create a database, user and grant permissions (this can be found in *'SQL Database files/Database Config.sql'*):
   `create user lego_set_checklist identified by 'password';`
   `create database lego_set_checklist_db;`
   `grant all privileges on lego_set_checklist_db.* to lego_set_checklist;`
2. Run the file *LegoSetCheckList-1.0.0.war* found in *Program/LegoSetCheckList/build/ibs/LegoSetCheckList-1.0.0.war* using the following in a terminal:
   `java -jar LegoSetCheckList-1.0.0.war`
3. You can then acess the website in a browser with the URl:
   `localhost:8080`

### Other Information

The Gantt charts for my project plan can be found in *Planning/'Project Timeline.gan'*
