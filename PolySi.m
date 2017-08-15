%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [5.43 5.43 5.43], 'mineral', 'Silicon', 'color', 'light blue')};

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'C:\Users\caexs\Documents\Work\Shahani\EBSD';

% which files to be imported
fname = [pname '\PolySi.ang'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = loadEBSD(fname,CS,'interface','ang',...
  'convertEuler2SpatialReferenceFrame');

close all 

% Remove grain noise and recalculate
[grains,ebsd.grainId] = calcGrains(ebsd,'angle',10*degree);
large_grains = grains(grains.grainSize >= 10);
ebsd_cleaned = ebsd(large_grains);
[grains_cleaned, ebsd_cleaned.grainId,ebsd_cleaned.mis2mean] = calcGrains(ebsd_cleaned, 'angle',10*degree);

% Plot misorientation boundaries
plot(ebsd_cleaned,'facealpha',0.5)
hold on
bound_Si = grains_cleaned.boundary('Si','Si');
plot(grains_cleaned.boundary)
% plot(bound_Si,bound_Si.misorientation.angle./degree,'linewidth',1.5)
% mtexColorMap blue2red
% mtexColorbar('Title','Misorientation in degrees')

gB = grains_cleaned.boundary('Si','Si');
% overlay CSL grain boundaries with the existing plot
figure
delta = 5*degree;
gB9 = gB(gB.isTwinning(CSL(9,ebsd_cleaned.CS),delta));
gB27 = gB(gB.isTwinning(CSL(27,ebsd_cleaned.CS),delta));

hold on
plot(gB9,'lineColor','m','linewidth',2,'DisplayName','CSL 9')
hold on
plot(gB27,'lineColor','c','linewidth',2,'DisplayName','CSL 27')
hold off

% Length fraction of CSL boundaries
% length = [0 0 0];
% length(1)=sum(gB3.segLength)/sum(gB.segLength);
% length(2)=sum(gB9.segLength)/sum(gB.segLength);
% length(3)=sum(gB27.segLength)/sum(gB.segLength);


%Angle Distribution
% figure
% plotAngleDistribution(grains_cleaned.boundary('Si','Si').misorientation, 'DisplayName', 'Si-Si')


% Boundary Axis Distribution
% figure
% mtexFig = newMtexFigure;
% plotAxisDistribution(bound_Si.misorientation, 'smooth', 'parent', mtexFig.gca)
% mtexTitle('Boundary Axis Distribution')
% mtexColorbar


% Misorientation Distribution Function
% mdf = calcMDF(grains_cleaned.boundary('Si','Si').misorientation,'halfwidth',2.5*degree,'bandwidth',32);
% figure
% plot(mdf,'axisAngle',(25:5:60)*degree,'colorRange',[0 15])
% 
% annotate(CSL(3,ebsd.CS),'label','$CSL_3$','backgroundcolor','w')
% annotate(CSL(5,ebsd.CS),'label','$CSL_5$','backgroundcolor','w')
% annotate(CSL(7,ebsd.CS),'label','$CSL_7$','backgroundcolor','w')
% annotate(CSL(9,ebsd.CS),'label','$CSL_9$','backgroundcolor','w')
% 
% drawNow(gcm)
