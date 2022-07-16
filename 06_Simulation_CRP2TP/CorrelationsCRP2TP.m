function [TechnicalProperties, matrixTP, minmaxTP, corrfunct] = CorrelationsCRP2TP(CustomerrelevantProperties)

%% Description:    
    % Designed by Ferdinand Schockenhoff (FTM, Techical University of Munich)
    %---------------------------------------
    % Created on September 2021
    % Last update: 28.04.2022
    %---------------------------------------
    % Version: Matlab2020b
    %---------------------------------------
    % Description: Correlations for the conection of the customer-relevant properties and the technical properties of autonomous vehicle concepts
    %              
    %---------------------------------------
    % Input: 
    % Customer-relevant properties    matrix (n x 28) n= number of vehicle concepts
    %---------------------------------------
    % Output:  
    % Technical properties           struct
    % matrixTP                       matrix (n x 29) with same information as Technical properties
    % maxminTP                       matrix (2 x 29) Max & Min values of TP
    % corrfunct                      char (1x29) with 29 stings of the correlation functions
    
    %Sources:
    %L. Langer, „Ableitung konzeptbestimmender technischer Werte autonomer Fahrzeuge anhand einer Marktanalyse“. Semester Thesis, 
    %    Institut of Automotive Technology, Technical University of Munich (TUM), Munich, 2021.
    %X. Duan, „Implementierung von Fahrzyklen anhand Fahrstileigenschaften autonomer Fahrzeuge“. Master Thesis, 
    %    Institut of Automotive Technology, Technical University of Munich (TUM), Munich, 2022.

 
%% Correlations

[numRows] = height(CustomerrelevantProperties);

matrixTP = zeros(numRows, 29);
minmaxTP = zeros(2,29);
%__________________________________________________________________________
% Dynamics

% Axial Dynamics
% Top Speed (Cumulative distribution function; positive; mu = 202.64; sigma = 29.061)
mu = 202.64; sigma = 29.061;
matrixTP (:,1) = round(icdf('Normal', (CustomerrelevantProperties(:,1)-4)/6, mu, sigma));
TechnicalProperties.Dy.TopSpeed.Value(:,1) = matrixTP (:,1);
minmaxTP (1,1) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Dy.TopSpeed.Max = minmaxTP (1,1);
minmaxTP (2,1) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Dy.TopSpeed.Min = minmaxTP (2,1);
corrfunct{1,1} = "@(x)3*(1+erf((x-202.64)/sqrt(2)/29.061))+4";

% Acceleration 0-100km/h (Cumulative distribution function; negative; mu = 8.6579; sigma = 2.4572)
mu = 8.6579; sigma = 2.4572;
matrixTP (:,2) = round(mu - (erfinv(((CustomerrelevantProperties(:,1)-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.Dy.Acceleration.Value(:,1) = matrixTP (:,2);
minmaxTP (1,2) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma), 1);
TechnicalProperties.Dy.Acceleration.Max = minmaxTP (1,2);
minmaxTP (2,2) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma), 1);
TechnicalProperties.Dy.Acceleration.Min = minmaxTP (2,2);
corrfunct{1,2} = "@(x)3*(1+erf(-1*(x-8.6579)/sqrt(2)/2.4572))+4";

% Lateral Dynamics
% height of the center of gravity (Cumulative distribution function; negative; mu = 649.35; sigma = 57.610)
mu = 649.35; sigma = 57.610;
matrixTP (:,3) = round(mu - (erfinv(((CustomerrelevantProperties(:,2)-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.COP.Value(:,1) = matrixTP (:,3);
minmaxTP (1,3) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.COP.Max = minmaxTP (1,3);
minmaxTP (2,3) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.COP.Min = minmaxTP (2,3);
corrfunct{1,3} = "@(x)3*(1+erf(-1*(x-649.35)/sqrt(2)/57.610))+4";

% Vertical Dynamics 
% Vertical Acceleration (Exponential function; x_0 = 0.8061; k = -8.3022) 
x_0 = 0.8061; k = -8.3022;
matrixTP (:,4) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,3)-4))-1))/-k),2);
TechnicalProperties.Dy.VerticalAcceleration.Value(:,1) = matrixTP (:,4);
minmaxTP (1,4) = round(x_0 + ((log((6./(9.95-4))-1))/-k), 2);
TechnicalProperties.Dy.VerticalAcceleration.Max = minmaxTP (1,4);
minmaxTP (2,4) = round(x_0 + ((log((6./(4.05-4))-1))/-k), 2);
TechnicalProperties.Dy.VerticalAcceleration.Min = minmaxTP (2,4);
corrfunct{1,4} = "@(x)6/(1+exp(-1*-8.3022*(x-0.8061)))+4";


% Turning Circle (Cumulative distribution function; negative; mu = 10.4371; sigma = 1.1596)
mu = 10.4371; sigma = 1.1596;
matrixTP (:,5) = round(mu - (erfinv(((CustomerrelevantProperties(:,4)-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.TurningCircle.Value(:,1) = matrixTP (:,5);
minmaxTP (1,5) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.TurningCircle.Max = minmaxTP (1,5);
minmaxTP (2,5) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma));
TechnicalProperties.Dy.TurningCircle.Min = minmaxTP (2,5);
corrfunct{1,5} = "@(x)3*(1+erf(-1*(x-10.4371)/sqrt(2)/1.1596))+4";

%_________________________________________________________________________
% Ergonomics

% Boarding Comfort
% Step Height (Exponential function; x_0 = 464.084; k = -0.0186;)
x_0 = 464.084; k = -0.0186;
matrixTP (:,6) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,5)-4))-1))/-k));
TechnicalProperties.Er.StepHeight.Value(:,1) = matrixTP (:,6);
minmaxTP (1,6) = round(x_0 + ((log((6./(9.95-4))-1))/-k));
TechnicalProperties.Er.StepHeight.Max = minmaxTP (1,6);
minmaxTP (2,6) = round(x_0 + ((log((6./(4.05-4))-1))/-k));
TechnicalProperties.Er.StepHeight.Min = minmaxTP (2,6);
corrfunct{1,6} = "@(x)6/(1+exp(-1*-0.0186*(x-464.084)))+4";


% Clearance Height  (Exponential function; x_0 = 1207.3; k = 0.0058;)
x_0 = 1575.7; k = 0.0113;
matrixTP (:,7) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,5)-4))-1))/-k));
TechnicalProperties.Er.ClearanceHeight.Value(:,1) = matrixTP (:,7);
minmaxTP (1,7) = round(x_0 + ((log((6./(4.05-4))-1))/-k));
TechnicalProperties.Er.ClearanceHeight.Max = minmaxTP (1,7);
minmaxTP (2,7) = round(x_0 + ((log((6./(9.95-4))-1))/-k)); 
TechnicalProperties.Er.ClearanceHeight.Min = minmaxTP (2,7);
corrfunct{1,7} = "@(x)6/(1+exp(-1*0.0113*(x-1575.7)))+4";

% Boarding Time
% Opening Door Width per Seat (Exponential function; x_0 = 576.19; k = 0.0071)
x_0 = 576.19; k = 0.0071;
matrixTP (:,8) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,6)-4))-1))/-k), -1);
TechnicalProperties.Er.DoorWidhtperSeat.Value(:,1) = matrixTP (:,8);
minmaxTP (1,8) = round(x_0 + ((log((6./(4.05-4))-1))/-k), -1);
if minmaxTP (1,8) < 0
    minmaxTP (1,8) = 0;
end
TechnicalProperties.Er.DoorWidhtperSeat.Max = minmaxTP (1,8);
minmaxTP (2,8) = round(x_0 + ((log((6./(9.95-4))-1))/-k), -1);
TechnicalProperties.Er.DoorWidhtperSeat.Min = minmaxTP (2,8);
corrfunct{1,8} = "@(x)6/(1+exp(-1*0.0071*(x-576.19)))+4";

% Leg Room
% Interior Dimension L53 (Cumulative distribution function; positive; mu = 684.12; sigma = 183.20)
mu = 684.12; sigma = 183.20;
matrixTP (:,9) = round(icdf('Normal', (CustomerrelevantProperties(:,7)-4)/6, mu, sigma), -1);
TechnicalProperties.Er.L53.Value(:,1) = matrixTP (:,9);
minmaxTP (1,9) = round(icdf('Normal', (4.05-4)/6, mu, sigma),-1);
TechnicalProperties.Er.L53.Max = minmaxTP (1,9);
minmaxTP (2,9) = round(icdf('Normal', (9.95-4)/6, mu, sigma),-1);
TechnicalProperties.Er.L53.Min = minmaxTP (2,9);
corrfunct{1,9} = "@(x)3*(1+erf((x-684.12)/sqrt(2)/183.20))+4";

% Shoulders Room
% Interior Dimension W3 per Seat (Cumulative distribution function; positive; mu = 511.54; sigma = 66.4)
mu = 511.54; sigma = 66.4;
matrixTP (:,10) = round(icdf('Normal', (CustomerrelevantProperties(:,8)-4)/6, mu, sigma), -1);
TechnicalProperties.Er.W3perSeat.Value(:,1) = matrixTP (:,10);
minmaxTP (1,10) = round(icdf('Normal', (4.05-4)/6, mu, sigma),-1);
TechnicalProperties.Er.W3perSeat.Max = minmaxTP (1,10);
minmaxTP (2,10) = round(icdf('Normal', (9.95-4)/6, mu, sigma),-1);
TechnicalProperties.Er.W3perSeat.Min = minmaxTP (2,10);
corrfunct{1,10} = "@(x)3*(1+erf((x-511.54)/sqrt(2)/66.4))+4";

% Head Room 
% Interior Dimension H61 (Cumulative distribution function; positive; mu = 984.83; sigma = 30.395)
mu = 984.83; sigma = 30.395;
matrixTP (:,11) = round(icdf('Normal', (CustomerrelevantProperties(:,9)-4)/6, mu, sigma));
TechnicalProperties.Er.H61.Value(:,1) = matrixTP (:,11);
minmaxTP (1,11) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Er.H61.Max = minmaxTP (1,11);
minmaxTP (2,11) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Er.H61.Min = minmaxTP (2,11);
corrfunct{1,11} = "@(x)3*(1+erf((x-984.83)/sqrt(2)/30.395))+4";

% Interior Acoustics
% Averaged Sound Pressure Level (with ANC)(Exponential function; x_0 = 62.83; k = -0.1971)
x_0 = 62.83; k = -0.1971;
matrixTP (:,12) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,10)-4))-1))/-k));
TechnicalProperties.Er.SoundLevel.Value(:,1) = matrixTP (:,12);
minmaxTP (1,12) = round(x_0 + ((log((6./(9.95-4))-1))/-k));
TechnicalProperties.Er.SoundLevel.Max = minmaxTP (1,12);
minmaxTP (2,12) = round(x_0 + ((log((6./(4.05-4))-1))/-k));
TechnicalProperties.Er.SoundLevel.Min = minmaxTP (2,12);
corrfunct{1,12} = "@(x)6/(1+exp(-1*-0.29163*(x-58.538)))+4";
%__________________________________________________________________________
% Security

% Passive Safety
% Crash Length (Front to Pedal)(Exponential function; x_0 = 630.67; k = 0.0105)
x_0 = 630.67; k = 0.0105;
matrixTP (:,13) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,11)-4))-1))/-k), -1);
TechnicalProperties.Se.PassiveSafety.Value(:,1) = matrixTP (:,13);
minmaxTP (1,13) = round(x_0 + ((log((6./(4.05-4))-1))/-k),-1);
TechnicalProperties.Se.PassiveSafety.Max = minmaxTP (1,13);
minmaxTP (2,13) = round(x_0 + ((log((6./(9.95-4))-1))/-k),-1);
TechnicalProperties.Se.PassiveSafety.Min = minmaxTP (2,13);
corrfunct{1,13} = "@(x)6/(1+exp(-1*0.0105*(x-630.67)))+4";

% Quality of Automation
% Disengagements per 100.000 km (Exponential function; x_0 = 32.246; k = -0.1316)
x_0 = 32.246; k = -0.1316;
matrixTP (:,14) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,14)-4))-1))/-k));
TechnicalProperties.Se.Disengagements.Value(:,1) = matrixTP (:,14);
minmaxTP (1,14) = round(x_0 + ((log((6./(9.95-4))-1))/-k));
if minmaxTP (1,14) <0
    minmaxTP (1,14)=0;
end
TechnicalProperties.Se.Disengagements.Max = minmaxTP (1,14);
minmaxTP (2,14) = round(x_0 + ((log((6./(4.05-4))-1))/-k));
TechnicalProperties.Se.Disengagements.Min = minmaxTP (2,14);
corrfunct{1,14} = "@(x)6/(1+exp(-1*-0.1316*(x-32.246)))+4";

% Active Safety
% Elasticity 60-100km/h (Cumulative distribution function; negative; mu = 4.7962; sigma = 1.4933)
mu = 4.7962; sigma = 1.4933;
matrixTP (:,15) = round(mu - (erfinv(((CustomerrelevantProperties(:,15)-4)/3)-1)*sqrt(2)*sigma), 1);
TechnicalProperties.Se.Elasticity.Value(:,1) = matrixTP (:,15);
minmaxTP (1,15) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.Se.Elasticity.Max = minmaxTP (1,15);
minmaxTP (2,15) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.Se.Elasticity.Min = minmaxTP (2,15);
corrfunct{1,15} = "@(x)3*(1+erf(-1*(x-4.7962)/sqrt(2)/1.4933))+4";

%__________________________________________________________________________
% Usability

% Bad Road Capability
% Ground Clearance (Cumulative distribution function; positive; mu = 157.07; sigma = 33.050)
mu = 157.07; sigma = 33.050;
matrixTP (:,16) = round(icdf('Normal', (CustomerrelevantProperties(:,16)-4)/6, mu, sigma));
TechnicalProperties.Us.GroundClearance.Value(:,1) = matrixTP (:,16);
minmaxTP (1,16) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Us.GroundClearance.Max = minmaxTP (1,16);
minmaxTP (2,16) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Us.GroundClearance.Min = minmaxTP (2,16);
corrfunct{1,16} = "@(x)3*(1+erf((x-157.07)/sqrt(2)/33.050))+4";

% Luggage Space
% Storage Volume for Passenger Vehicle (Cumulative distribution function; positive; mu = 450.38; sigma = 142.46)
mu = 450.38; sigma = 142.46;
matrixTP (:,17) = round(icdf('Normal', (CustomerrelevantProperties(:,17)-4)/6, mu, sigma));
TechnicalProperties.Us.StoragePassenger.Value(:,1) = matrixTP (:,17);
minmaxTP (1,17) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Us.StoragePassenger.Max = minmaxTP (1,17);
minmaxTP (2,17) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Us.StoragePassenger.Min = minmaxTP (2,17);
corrfunct{1,17} = "@(x)3*(1+erf((x-450.38)/sqrt(2)/142.46))+4";

% Storage Volume for Load Vehicle(Exponential function; x_0 = 5709 ; k = 0.000851)
x_0 = 5709 ; k = 0.000851;
matrixTP (:,18) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,17)-4))-1))/-k), -1);
TechnicalProperties.Us.StorageLoad.Value(:,1) = matrixTP (:,18);
minmaxTP (1,18) = round(x_0 + ((log((6./(4.05-4))-1))/-k), -1);
TechnicalProperties.Us.StorageLoad.Max = minmaxTP (1,18);
minmaxTP (2,18) = round(x_0 + ((log((6./(9.95-4))-1))/-k), -1);
TechnicalProperties.Us.StorageLoad.Min = minmaxTP (2,18);
corrfunct{1,18} = "@(x)6/(1+exp(-1*0.000851*(x-5709)))+4";


% Radius of Movement
% Range (Cumulative distribution function; positive; mu = 365.54; sigma = 121.56)
mu = 365.54; sigma = 121.56;
matrixTP (:,19) = round(icdf('Normal', (CustomerrelevantProperties(:,18)-4)/6, mu, sigma));
TechnicalProperties.Us.Range.Value(:,1) = matrixTP (:,19);
minmaxTP (1,19) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Us.Range.Max = minmaxTP (1,19);
minmaxTP (2,19) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Us.Range.Min = minmaxTP (2,19);
corrfunct{1,19} = "@(x)3*(1+erf((x-365.54)/sqrt(2)/121.56))+4";


% Costs
% Acquisition Costs (with additional sensors)(Cumulative distribution function; negative; mu = 38820; sigma = 19142)
mu = 38820; sigma = 19142;
matrixTP (:,20) = round(mu - (erfinv(((CustomerrelevantProperties(:,19)-4)/3)-1)*sqrt(2)*sigma), -2);
TechnicalProperties.Us.Costs.Value(:,1) = matrixTP (:,20);
minmaxTP (1,20) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),-2);
if minmaxTP (1,20) <0
    minmaxTP (1,20)=0;
end
TechnicalProperties.Us.Costs.Max = minmaxTP (1,20);
minmaxTP (2,20) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma), -2);
TechnicalProperties.Us.Costs.Min = minmaxTP (2,20);
corrfunct{1,20} = "@(x)3*(1+erf(-1*(x-38820)/sqrt(2)/19142))+4";

% Ecology
% Production Emissions (Cumulative distribution function; negative; mu = 5.1433; sigma = 2.1628)
mu = 5.1433; sigma = 2.1628;
matrixTP (:,21) = round(mu - (erfinv(((CustomerrelevantProperties(:,20)-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.Us.Emissions.Value(:,1) = matrixTP (:,21);
minmaxTP (1,21) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),1);
if minmaxTP (1,21) <0
    minmaxTP (1,21)=0;
end
TechnicalProperties.Us.Emissions.Max = minmaxTP (1,21);
minmaxTP (2,21) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.Us.Emissions.Min = minmaxTP (2,21);
corrfunct{1,21} = "@(x)3*(1+erf(-1*(x-5.1433)/sqrt(2)/2.1628))+4";

% Passengers
% Number of Seats (Exponential function; x_0 = 3.264 ; k = 0.7109)
x_0 = 3.264; k = 0.7109;
matrixTP (:,22) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,21)-4))-1))/-k));
TechnicalProperties.Us.Seats.Value(:,1) = matrixTP (:,22);
minmaxTP (1,22) = round(x_0 + ((log((6./(4.05-4))-1))/-k));
if minmaxTP (1,22) <0
    minmaxTP (1,22)=0;
end
TechnicalProperties.Us.Seats.Max = minmaxTP (1,22);
minmaxTP (2,22) = round(x_0 + ((log((6./(9.9-4))-1))/-k));
TechnicalProperties.Us.Seats.Min = minmaxTP (2,22);
corrfunct{1,22} = "@(x)6/(1+exp(-1*0.7109*(x-3.264)))+4";

%__________________________________________________________________________
% DrivingStyle

% DS Comfort
% Jerk_RMS (Cumulative distribution function; negative; mu = 0.8438; sigma = 0.3890)
mu = 0.8438; sigma = 0.3890;
matrixTP (:,23) = round(mu - (erfinv(((CustomerrelevantProperties(:,22)-4)/3)-1)*sqrt(2)*sigma),2);
TechnicalProperties.DS.Jerk.Value(:,1) = matrixTP (:,23);
minmaxTP (1,23) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),2);
if minmaxTP (1,23) <0
    minmaxTP (1,23)=0;
end
TechnicalProperties.DS.Jerk.Max = minmaxTP (1,23);
minmaxTP (2,23) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma),2);
TechnicalProperties.DS.Jerk.Min = minmaxTP (2,23);
corrfunct{1,23} = "@(x)3*(1+erf(-1*(x-0.8438)/sqrt(2)/0.3890))+4";

% Accleration_Sick (Cumulative distribution function; negative; mu = 0.3365; sigma = 0.2160)
mu = 0.3365; sigma = 0.2160;
matrixTP (:,24) = round(mu - (erfinv(((CustomerrelevantProperties(:,22)-4)/3)-1)*sqrt(2)*sigma),2);
TechnicalProperties.DS.Acceleration.Value(:,1) = matrixTP (:,24);
minmaxTP (1,24) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),2);
if minmaxTP (1,24) <0
    minmaxTP (1,24)=0;
end
TechnicalProperties.DS.Acceleration.Max = minmaxTP (1,24);
minmaxTP (2,24) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma),2);
TechnicalProperties.DS.Acceleration.Min = minmaxTP (2,24);
corrfunct{1,24} = "@(x)3*(1+erf(-1*(x-0.3365)/sqrt(2)/0.2160))+4";

% DS Safety
% homeostatic risk perception (Cumulative distribution function; positive; mu = 0.8617; sigma = 0.11481)
% (G. Lu, B. Cheng, Q. Lin, und Y. Wang, “Quantitative indicator of homeostatic risk perception
%    in car following,” Safety Science, Bd. 50, Rn. 9, S. 1898–1905, 2012)
mu = 0.8617; sigma = 0.11481;
matrixTP (:,25) = round(icdf('Normal', (CustomerrelevantProperties(:,23)-4)/6, mu, sigma), 2);
TechnicalProperties.DS.Distance.Value(:,1) = matrixTP (:,25);
minmaxTP (1,25) = round(icdf('Normal', (4.05-4)/6, mu, sigma), 2);
TechnicalProperties.DS.Distance.Max = minmaxTP (1,25);
minmaxTP (2,25) = round(icdf('Normal', (9.95-4)/6, mu, sigma), 2);
TechnicalProperties.DS.Distance.Min = minmaxTP (2,25);
corrfunct{1,25} = "@(x)3*(1+erf((x-0.8617)/sqrt(2)/0.11481))+4";

% DS Time Potential
% Fastness (linear correlation; negative; A = -30; B = 67)
% (X. Duan, „Implementierung von Fahrzyklen anhand Fahrstileigenschaften autonomer Fahrzeuge“. Master Thesis, 
%    Institut of Automotive Technology, Technical University of Munich (TUM), Munich, 2022.)
A = -30; B = 67;
matrixTP (:,26) = round((CustomerrelevantProperties(:,24)-B)/A, 2);
TechnicalProperties.DS.TimePotential.Value(:,1) = matrixTP (:,26);
minmaxTP (1,26) = (10-B)/A;
TechnicalProperties.DS.TimePotential.Max = minmaxTP (1,26);
minmaxTP (2,26) = (4-B)/A;
TechnicalProperties.DS.TimePotential.Min = minmaxTP (2,26);
corrfunct{1,26} = "@(x)-30*x+67";

% DS Consumption
% Consumption per 100km (Cumulative distribution function; negative; mu = 17.172; sigma = 2.7314)
mu = 17.172; sigma = 2.7314;
matrixTP (:,27) = round(mu - (erfinv(((CustomerrelevantProperties(:,25)-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.DS.Consumption.Value(:,1) = matrixTP (:,27);
minmaxTP (1,27) = round(mu - (erfinv(((9.95-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.DS.Consumption.Max = minmaxTP (1,27);
minmaxTP (2,27) = round(mu - (erfinv(((4.05-4)/3)-1)*sqrt(2)*sigma),1);
TechnicalProperties.DS.Consumption.Min = minmaxTP (2,27);
corrfunct{1,27} = "@(x)3*(1+erf(-1*(x-17.172)/sqrt(2)/2.7314))+4";


%__________________________________________________________________________
% Luxury

% Built-In Infotainment
% Screen Area per Seat (Exponential function; x_0 = 569.59 ; k = 0.0028)
x_0 = 569.59 ; k = 0.0028;
matrixTP (:,28) = round(x_0 + ((log((6./(CustomerrelevantProperties(:,26)-4))-1))/-k), -1);
TechnicalProperties.Lu.Screen.Value(:,1) = matrixTP (:,28);
minmaxTP (1,28) = round(x_0 + ((log((6./(4.05-4))-1))/-k),-1);
if minmaxTP (1,28) <0
    minmaxTP (1,28)=0;
end
TechnicalProperties.Lu.Screen.Max = minmaxTP (1,28);
minmaxTP (2,28) = round(x_0 + ((log((6./(9.95-4))-1))/-k),-1);
TechnicalProperties.Lu.Screen.Min = minmaxTP (2,28);
corrfunct{1,28} = "@(x)6/(1+exp(-1*0.0028*(x-569.59)))+4";

% Exterior Design
% Wheel Diameter (Cumulative distribution function; positive; mu = 660.51; sigma = 42.258)
mu = 660.51; sigma = 42.258;
matrixTP (:,29) = round(icdf('Normal', (CustomerrelevantProperties(:,28)-4)/6, mu, sigma));
TechnicalProperties.Lu.Wheel.Value(:,1) = matrixTP (:,29);
minmaxTP (1,29) = round(icdf('Normal', (4.05-4)/6, mu, sigma));
TechnicalProperties.Lu.Wheel.Max = minmaxTP (1,29);
minmaxTP (2,29) = round(icdf('Normal', (9.95-4)/6, mu, sigma));
TechnicalProperties.Lu.Wheel.Min = minmaxTP (2,29);
corrfunct{1,29} = "@(x)3*(1+erf((x-660.51)/sqrt(2)/42.258))+4";

end

