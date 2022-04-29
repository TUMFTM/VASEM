# VASEM
Vehicle concept development for Autonomous, Shared and Electric Mobility


  
## Running the Model/Code

To start the simulation, you have to run the GUI  
```
Start.mlapp
```

The GUI of the tool steps are shown in the following figure. The numbers will explain its functionality.

### START
```
Start.mlapp
```
The app Start gives an overview about the different process steps and allows to open every step/ app.

![00_Start](https://user-images.githubusercontent.com/72914074/165953452-38df78d6-6bfc-4495-a899-e87a1ab4cbfc.png)

1 Buttons to choose the wanted app  
2 Description  of the chosen app  
3 Figure of the chosen app  
4 Button to proceed to the chosen app  


### User Needs
```
UserNeeds.mlapp
```
The app User Needs is the initial start of the development vehicle concepts for autonomous, shared, and electric mobility. The User has to fill out the required mobility users.

![01_UserNeeds](https://user-images.githubusercontent.com/72914074/165953617-ceefd27e-ef81-4084-b8bf-27c54fea83af.png)

1: Save, Load, Reset or Update the data   
2: Set the parameters number of users (1-6) and the desired user fulfillment  of the simulated vehicle fleet (50%-80%)   
3: Option to choose a predefined scenario   
4: Selected the display option   
5: Selected the needs of each user manually   
6: Proceed to the next process step by an optimazation   
7: Home Button brings you bacl to the Start app (exists in every App)


### Vehicle Provision
```
VehicleProvision.mlapp
```
The app Vehicle Provision illustrates the results of the optimization that minimizes the number of vehicles to achieve the required level of users' fulfillment.

![02_Vehicle Provision](https://user-images.githubusercontent.com/72914074/165949884-b473a4bf-7824-469f-ba39-6d38690d0036.png)

1: Load previously simulated data   
2: Selected the display option   
3: Figures of the simulated vehicles   
4: Describtion/ Legend of the simulated vehicles    
5: Proceed to the next process step by a fuzzy logic   

### Customer-relevant Properties
```
CustomerrelevantProperties.mlapp
```
The Customer-relevant Properties are calculated from the users’ needs and shown in a nominal scale. 

![03_Customer-relevant Properties](https://user-images.githubusercontent.com/72914074/165951341-ca5a9abb-c662-415b-835f-8083be883ee4.png)

1: Load, Save, Reset and Manipilate the previously simulated data   
2: Selected the display option (Customer-relevant Properties of one Vehicle Concept and its related Vehicle Provison OR Customer-relevant Properties of all Vehicle Concepts)   
3: Select the Vehicle Concepts you want to illustrate. Push Update to confirm the selection.   
4: The illustration of Customer-relevant Properties of all Vehicle Concepts   
5: Switch between the Secondary Activites and the Character/ Mobility of the Vehicle provision in the illustration of Customer-relevant Properties of one Vehicle Concept   
6: Illustration of Customer-relevant Properties of one Vehicle Concept and Manipulate mode to change the values   
7: Proceed to the next process step by correlation functions   


### Technical Properties
```
TechnicalProperties.mlapp
```
The Technical Properties are derived from the customer-relevant properties by correlation functions. They describe the properties in a technical physical manner.

![04_Technical Properties](https://user-images.githubusercontent.com/72914074/165953933-11fcc281-2757-4a02-82bc-73f15bb22795.png)

1: Load, Save, Reset and Manipilate the previously simulated data   
2: Selected the display option (all Technical Properties for one Vehicle concept, a group of Technical Proberties for all Vehicle Concepts, the previously simulated Customer-relevant Properties of all Vehicle Concepts, or the Correlatiosn between them)   
3: Select the Vehicle Concepts you want to illustrate. At maximum a selection of 6 vehicle concepts is possible.   
4: The illustration of All Technical Properties for the selected vehicle concept.   
5: The illustration of the correlation functions.   
6: Switch between the different groups of technical proberties   
7: Proceed to the next process step by calculation.   


### Design Parameter
```
DesignParameter.mlapp
```
The Design Parameter provides every needed parameter to simulate the final vehicle concept.


### Vehicle Concept
```
VehicleConcepts.mlapp
```
The app Vehicle Concept presents the results of the entire process. The final vehicle concepts with their package and further attributes are shown.

  
## Deployment
  
* [Matlab](https://de.mathworks.com/products/matlab.html) R2020b
  
## Prerequisites

- Global Optimazation Toolbox
- Statistic and Machine Learning Toolbox
- Fuzzy Logic Toolbox
  
## Contributing and Support
  
We are strongly encouraged to improve quality and functionality of VASEM. If you have any Feedback don't hesitate to contact the authors or the group leader of the vehicle concept research group at FTM of the TUM.

## Versioning
  
V1.0 initial public version of VASEM
  
## Authors
- Ferdinand Schockenhoff (Institute for Automotive Technology, Technical University of Munich): Creation of research topic, Conceptualization, Code creating, Code detailing, Code documentation, Supervison
- Maximilian Zähringer (Institute for Automotive Technology, Technical University of Munich): Code creating, Code documentation (Backend User Needs to Vehicle Provison to Customer-relevant Properties)
- Marc Raudszus (Technical University of Munich): Code creating, Code documentation (Backend Technical Properties to Design Parameters, Frontend Design Parameters and Vehicle Concept)
- David Fischer (Technical University of Munich): Code creating, Code documentation (Frontend User Needs, Vehicle Provision and Customer-relevant Properties)
  
## License
This project is licensed under the LGPL License - see the LICENSE.md file for details.
 
 
## Sources
We used the AuVeCoDe of König:
* Repository: https://github.com/TUMFTM/AuVeCoDe
* Dissertation: Adrian König, „Methodik zur Auslegung von autonomen Fahrzeugkonzepten“. Dissertation, Lehrstuhl für Fahrzeugtechnik, Technische Universität München (TUM), München, 2022. (in progress)


The following dissertation describes the development of the tool:
Ferdinand Schockenhoff, „Fahrzeugkonzeptentwicklung für autonome, geteilte und elektrische Mobilität“. Dissertation, Lehrstuhl für Fahrzeugtechnik, Technische Universität München (TUM), München, 2022. (in progress)
