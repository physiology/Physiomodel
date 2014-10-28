within Physiomodel;
model Proteins_test_SI
  import Physiomodel;
Physiomodel.CardioVascular.CVS_Dynamic             cardioVascularSystem
    annotation (Placement(transformation(extent={{40,72},{60,94}})));
  Physiomodel.Metabolism.NutrientsAndMetabolism  nutrientsAndMetabolism
    annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
  Physiomodel.Electrolytes.Electrolytes            electrolytes
    annotation (Placement(transformation(extent={{74,-34},{94,-14}})));
  Physiomodel.Hormones.Hormones                hormones
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Physiomodel.Nerves.Nerves                  nerves
    annotation (Placement(transformation(extent={{74,38},{94,58}})));
  Physiomodel.Setup.IO_Bus.InputFromFile_SI     setup
    annotation (Placement(transformation(extent={{-16,-106},{4,-86}})));
  Physiomodel.Water.Water3                  water
    annotation (Placement(transformation(extent={{-86,-6},{-66,14}})));
  Physiomodel.Proteins.Proteins proteins
    annotation (Placement(transformation(extent={{-48,-28},{-28,-8}})));
  Physiomodel.Status.TissuesFitness          status
    annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
  Physiomodel.Gases.IO_Bus.InputFromFile_SI gases
    annotation (Placement(transformation(extent={{-76,-64},{-56,-44}})));
  Physiomodel.Heat.Heat2                   heat
    annotation (Placement(transformation(extent={{-28,30},{-48,50}})));
equation
  connect(setup.busConnector,hormones. busConnector) annotation (Line(
      points={{-6,-96},{-6,21.9},{43.9,21.9}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector,proteins. busConnector) annotation (Line(
      points={{-6,-96},{-6,-9.7},{-31.7,-9.7}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector,cardioVascularSystem. busConnector)
                                                annotation (Line(
      points={{-6,-96},{-6,91.8},{42,91.8}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector,nutrientsAndMetabolism. busConnector)
    annotation (Line(
      points={{-6,-96},{-6,78},{-70,78}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector,water. busConnector) annotation (Line(
      points={{-6,-96},{-6,11},{-69,11}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector,nerves. busConnector) annotation (Line(
      points={{-6,-96},{-6,55.6},{76.2,55.6}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(status.busConnector,setup. busConnector)         annotation (Line(
      points={{43.2,-60.8},{-6,-60.8},{-6,-96}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(electrolytes.busConnector,setup. busConnector) annotation (Line(
      points={{74,-20},{-6,-20},{-6,-96}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gases.busConnector,setup. busConnector) annotation (Line(
      points={{-66,-54},{-6,-54},{-6,-96}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heat.busConnector,setup. busConnector) annotation (Line(
      points={{-28.6,49.6},{-6,49.6},{-6,-96}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=864000),
    __Dymola_experimentSetupOutput);
end Proteins_test_SI;
