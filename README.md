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

![00_Start_1](https://user-images.githubusercontent.com/72914074/165326073-04ae8ff2-924e-445d-b6a9-1ba2db32caaa.png)
![00_Start_2](https://user-images.githubusercontent.com/72914074/165326123-573aba08-2f39-4d76-96cd-b4751ca9e899.png)

1 Buttons to choose the wanted app  
2 Description  of the chosen app  
3 Figure of the chosen app  
4 Button to proceed to the chosen app  


### User Needs
```
UserNeeds.mlapp
```
The app User Needs is the initial start of the development vehicle concepts for autonomous, shared, and electric mobility. The User has to fill out the required mobility users.

![01_UserNeeds_1](https://user-images.githubusercontent.com/72914074/165335064-6fd8edac-627f-4bd3-b4b4-08dc2dd5e549.png)

1: Save, Load, Reset or Update the data   
2: Set the parameters number of users (1-6) and the desired user fulfillment  of the simulated vehicle fleet (50%-80%)   
3: Option to choose a predefined scenario   
4: Selected the display option   
5: Selected the needs of each user manually   
6: Proceed to the next process step


### Vehicle Provision
```
VehicleProvision.mlapp
```
The app Vehicle Provision illustrates the results of the optimization that minimizes the number of vehicles to achieve the required level of users' fulfillment. 

### Customer-relevant Properties
```
CustomerrelevantProperties.mlapp
```

The Customer-relevant properties are calculated from the users’ needs and shown in a nominal scale. 

### Technical Properties
```
TechnicalProperties.mlapp
```
The Technical Properties are derived from the customer-relevant properties by correlation functions. They describe the properties in a technical physical manner.

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
