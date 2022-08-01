# Lego: Set Checklist Creator

## Information about this repository

### List of Software Files
<pre>
Program <br/>
└─ LegoSetCheckList <br/>
├─ bin <br/>
│  ├─ default <br/>
│  ├─ main <br/>
│  │  ├─ lego<br/>
│  │  │  └─ checklist<br/>
│  │  │     ├─ controller<br/>
│  │  │     │  ├─ DatabaseController$1.class<br/>
│  │  │     │  ├─ DatabaseController$2.class<br/>
│  │  │     │  ├─ DatabaseController$3.class<br/>
│  │  │     │  ├─ DatabaseController$4.class<br/>
│  │  │     │  ├─ DatabaseController$5.class<br/>
│  │  │     │  ├─ DatabaseController$6.class<br/>
│  │  │     │  ├─ DatabaseController$7.class<br/>
│  │  │     │  ├─ DatabaseController.class<br/>
│  │  │     │  ├─ MainController$1.class<br/>
│  │  │     │  ├─ MainController.class<br/>
│  │  │     │  ├─ PieceController$1.class<br/>
│  │  │     │  ├─ PieceController.class<br/>
│  │  │     │  ├─ PieceTypeController.class<br/>
│  │  │     │  ├─ SetController$1.class<br/>
│  │  │     │  ├─ SetController.class<br/>
│  │  │     │  ├─ ThemeController$1.class<br/>
│  │  │     │  └─ ThemeController.class<br/>
│  │  │     ├─ domain<br/>
│  │  │     │  ├─ Account.class<br/>
│  │  │     │  ├─ Piece.class<br/>
│  │  │     │  ├─ PieceFound.class<br/>
│  │  │     │  ├─ Set.class<br/>
│  │  │     │  ├─ SetInProgress.class<br/>
│  │  │     │  ├─ SetInSetList.class<br/>
│  │  │     │  ├─ Set_list.class<br/>
│  │  │     │  └─ Theme.class<br/>
│  │  │     ├─ repository<br/>
│  │  │     │  ├─ AccountRepository.class<br/>
│  │  │     │  ├─ PieceFoundRepository.class<br/>
│  │  │     │  ├─ SetInfoRepository.class<br/>
│  │  │     │  ├─ SetInProgressRepository.class<br/>
│  │  │     │  ├─ SetInSetListRepository.class<br/>
│  │  │     │  └─ Set_listRepository.class<br/>
│  │  │     ├─ validator<br/>
│  │  │     │  └─ AccountValidator.class<br/>
│  │  │     └─ LegoSetCheckListApplication.class<br/>
│  │  ├─ templates<br/>
│  │  └─ application.properties<br/>
│  └─ test<br/>
│     └─ lego<br/>
│        └─ checklist<br/>
│           └─ LegoSetCheckListApplicationTests.class<br/>
├─ build<br/>
│  ├─ classes<br/>
│  │  └─ java<br/>
│  │     └─ main<br/>
│  │        └─ lego<br/>
│  │           └─ checklist<br/>
│  │              ├─ controller<br/>
│  │              │  ├─ DatabaseController$1.class<br/>
│  │              │  ├─ DatabaseController$2.class<br/>
│  │              │  ├─ DatabaseController$3.class<br/>
│  │              │  ├─ DatabaseController$4.class<br/>
│  │              │  ├─ DatabaseController$5.class<br/>
│  │              │  ├─ DatabaseController$6.class<br/>
│  │              │  ├─ DatabaseController$7.class<br/>
│  │              │  ├─ DatabaseController.class<br/>
│  │              │  ├─ MainController$1.class<br/>
│  │              │  ├─ MainController.class<br/>
│  │              │  ├─ PieceController$1.class<br/>
│  │              │  ├─ PieceController.class<br/>
│  │              │  ├─ PieceTypeController.class<br/>
│  │              │  ├─ SetController$1.class<br/>
│  │              │  ├─ SetController.class<br/>
│  │              │  ├─ ThemeController$1.class<br/>
│  │              │  └─ ThemeController.class<br/>
│  │              ├─ domain<br/>
│  │              │  ├─ Account.class<br/>
│  │              │  ├─ Piece.class<br/>
│  │              │  ├─ PieceFound.class<br/>
│  │              │  ├─ Set.class<br/>
│  │              │  ├─ SetInProgress.class<br/>
│  │              │  ├─ SetInSetList.class<br/>
│  │              │  ├─ Set_list.class<br/>
│  │              │  └─ Theme.class<br/>
│  │              ├─ repository<br/>
│  │              │  ├─ AccountRepository.class<br/>
│  │              │  ├─ PieceFoundRepository.class<br/>
│  │              │  ├─ SetInfoRepository.class<br/>
│  │              │  ├─ SetInProgressRepository.class<br/>
│  │              │  ├─ SetInSetListRepository.class<br/>
│  │              │  └─ Set_listRepository.class<br/>
│  │              ├─ validator<br/>
│  │              │  └─ AccountValidator.class<br/>
│  │              └─ LegoSetCheckListApplication.class<br/>
│  ├─ generated<br/>
│  │  └─ sources<br/>
│  │     ├─ annotationProcessor<br/>
│  │     │  └─ java<br/>
│  │     │     └─ main<br/>
│  │     └─ headers<br/>
│  │        └─ java<br/>
│  │           └─ main<br/>
│  ├─ libs<br/>
│  │  └─ LegoSetCheckList-1.0.0.war<br/>
│  ├─ resources<br/>
│  │  └─ main<br/>
│  │     ├─ static<br/>
│  │     ├─ templates<br/>
│  │     └─ application.properties<br/>
│  ├─ tmp<br/>
│  │  ├─ bootWar<br/>
│  │  │  └─ MANIFEST.MF<br/>
│  │  └─ compileJava<br/>
│  │     └─ previous-compilation-data.bin<br/>
│  └─ bootWarMainClassName<br/>
├─ gradle<br/>
│  └─ wrapper<br/>
│     ├─ gradle-wrapper.jar<br/>
│     └─ gradle-wrapper.properties<br/>
├─ src<br/>
│  ├─ main<br/>
│  │  ├─ java<br/>
│  │  │  └─ lego<br/>
│  │  │     └─ checklist<br/>
│  │  │        ├─ controller<br/>
│  │  │        │  ├─ DatabaseController.java<br/>
│  │  │        │  ├─ MainController.java<br/>
│  │  │        │  ├─ PieceController.java<br/>
│  │  │        │  ├─ PieceTypeController.java<br/>
│  │  │        │  ├─ SetController.java<br/>
│  │  │        │  └─ ThemeController.java<br/>
│  │  │        ├─ domain<br/>
│  │  │        │  ├─ Account.java<br/>
│  │  │        │  ├─ Piece.java<br/>
│  │  │        │  ├─ PieceFound.java<br/>
│  │  │        │  ├─ Set.java<br/>
│  │  │        │  ├─ SetInProgress.java<br/>
│  │  │        │  ├─ SetInSetList.java<br/>
│  │  │        │  ├─ Set_list.java<br/>
│  │  │        │  └─ Theme.java<br/>
│  │  │        ├─ repository<br/>
│  │  │        │  ├─ AccountRepository.java<br/>
│  │  │        │  ├─ PieceFoundRepository.java<br/>
│  │  │        │  ├─ SetInfoRepository.java<br/>
│  │  │        │  ├─ SetInProgressRepository.java<br/>
│  │  │        │  ├─ SetInSetListRepository.java<br/>
│  │  │        │  └─ Set_listRepository.java<br/>
│  │  │        ├─ validator<br/>
│  │  │        │  └─ AccountValidator.java<br/>
│  │  │        └─ LegoSetCheckListApplication.java<br/>
│  │  ├─ resources<br/>
│  │  │  ├─ static<br/>
│  │  │  ├─ templates<br/>
│  │  │  └─ application.properties<br/>
│  │  └─ webapp<br/>
│  │     └─ WEB-INF<br/>
│  │        └─ views<br/>
│  │           ├─ accessDenied.jsp<br/>
│  │           ├─ index.jsp<br/>
│  │           ├─ profile.jsp<br/>
│  │           ├─ search.jsp<br/>
│  │           ├─ showPiece_list.jsp<br/>
│  │           ├─ showSet.jsp<br/>
│  │           ├─ showSetList.jsp<br/>
│  │           ├─ showSetLists.jsp<br/>
│  │           └─ showSetsInProgress.jsp<br/>
│  └─ test<br/>
│     └─ java<br/>
│        └─ lego<br/>
│           └─ checklist<br/>
│              └─ LegoSetCheckListApplicationTests.java<br/>
├─ build.gradle<br/>
├─ gradlew<br/>
├─ gradlew.bat<br/>
├─ HELP.md<br/>
└─ settings.gradle<br/>

</pre>

<br/>

<br/>

### Installation of software

*You must have at least Java 8 or JDK 8 to run this software*

1. First start a mysql server and run the following to create a database, user and grant permissions (this can be found in *'SQL Database files/Database Config.sql'*):
   `create user lego_set_checklist identified by 'password';`
   `create database lego_set_checklist_db;`
   `grant all privileges on lego_set_checklist_db.* to lego_set_checklist;`
2. Run the file *LegoSetCheckList-1.0.0.war* found in *Program/LegoSetCheckList/build/libs/LegoSetCheckList-1.0.0.war* using the following in a terminal:
   `java -jar LegoSetCheckList-1.0.0.war`
3. You can then acess the website in a browser with the URl:
   `localhost:8080`

### Other Information

The Gantt charts for my project plan can be found in *Planning/'Project Timeline.gan'*
