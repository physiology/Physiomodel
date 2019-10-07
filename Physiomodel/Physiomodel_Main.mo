within Physiomodel;
model Physiomodel_Main "Main model"
  import Physiomodel;
  extends Physiolibrary.Icons.PhysicalExercise;

  Physiomodel.CardioVascular.CardioVascularSystem cardioVascularSystem
    annotation (Placement(transformation(extent={{58,74},{78,96}})));
  Physiomodel.Metabolism.NutrientsAndMetabolism nutrientsAndMetabolism
    annotation (Placement(transformation(extent={{-90,66},{-70,86}})));
  Physiomodel.Electrolytes.Electrolytes electrolytes
    annotation (Placement(transformation(extent={{74,-28},{94,-8}})));
  Physiomodel.Hormones.Hormones
                    hormones
    annotation (Placement(transformation(extent={{40,12},{60,32}})));
  Physiomodel.Nerves.Nerves       nerves
    annotation (Placement(transformation(extent={{74,44},{94,64}})));
  Physiomodel.Water.Water water
    annotation (Placement(transformation(extent={{-86,0},{-66,20}})));
  Physiomodel.Proteins.Proteins
                    proteins
    annotation (Placement(transformation(extent={{-48,-22},{-28,-2}})));
  Physiomodel.Status.TissuesFitness status
    annotation (Placement(transformation(extent={{42,-74},{62,-54}})));
  Physiomodel.Gases.Gases          gases(oxygen(tissuesO2(skeletalMuscleO2(
            O2Tissue(
            a(start=0.518),
            pCO2(displayUnit="mmHg"),
            sO2CO(start=0.367),
            pO2(start=5332.8954966, displayUnit="mmHg"))))))
    annotation (Placement(transformation(extent={{-76,-60},{-56,-40}})));
  Physiomodel.Heat.Heat2 heat
    annotation (Placement(transformation(extent={{-28,36},{-48,56}})));
  Physiolibrary.Types.BusConnector busConnector
    annotation (Placement(transformation(extent={{-20,70},{20,110}}),
        iconTransformation(extent={{-20,70},{20,110}})));
  Physiomodel.Setup.ConstantSetup constantSetup
    annotation (Placement(transformation(extent={{-280,-76},{-260,-56}})));
  Physiomodel.Setup.ConstantSetup constant_Setup
    annotation (Placement(transformation(extent={{-16,-84},{4,-64}})));
  Physiolibrary.Types.Constants.VolumeFlowRateConst ECMO_BloodFlow(k=
        8.3333333333333e-5)
    annotation (Placement(transformation(extent={{-42,74},{-34,82}})));
  Physiolibrary.Types.Constants.VolumeFlowRateConst ECMO_Ventilation(k=
        8.3333333333333e-5)
    annotation (Placement(transformation(extent={{-42,60},{-34,68}})));
equation

  connect(status.busConnector, busConnector) annotation (Line(
      points={{43.2,-54.8},{7.6,-54.8},{7.6,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(busConnector, gases.busConnector) annotation (Line(
      points={{0,90},{8,90},{8,-42},{-58,-42}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nutrientsAndMetabolism.busConnector, busConnector) annotation (Line(
      points={{-72,84},{-36,84},{-36,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(cardioVascularSystem.busConnector, busConnector) annotation (Line(
      points={{60,93.8},{8,93.8},{8,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heat.busConnector, busConnector) annotation (Line(
      points={{-28.6,55.6},{8,55.6},{8,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nerves.busConnector, busConnector) annotation (Line(
      points={{76.2,61.6},{8,61.6},{8,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(water.busConnector, busConnector) annotation (Line(
      points={{-69,17},{8,17},{8,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hormones.busConnector, busConnector) annotation (Line(
      points={{43.9,27.9},{8,27.9},{8,90},{0,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(electrolytes.busConnector, gases.busConnector) annotation (Line(
      points={{74,-14},{8,-14},{8,-42},{-58,-42}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(proteins.busConnector, gases.busConnector) annotation (Line(
      points={{-31.7,-3.7},{8,-4},{8,-42},{-58,-42}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(constant_Setup.busConnector, gases.busConnector) annotation (Line(
      points={{-3.4,-71.8},{-3.4,-48},{8,-48},{8,-42},{-58,-42}},
      color={0,0,255},
      thickness=0.5));
  connect(ECMO_BloodFlow.y, busConnector.ECMO_BloodFlow) annotation (Line(
        points={{-33,78},{-16,78},{-16,90},{0,90}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ECMO_Ventilation.y, busConnector.ECMO_Ventilation) annotation (Line(
        points={{-33,64},{-14,64},{-14,90},{0,90}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation ( Documentation(info="<html>
<p><h4><font color=\"#008000\">QHP Golem Edition</font></h4></p>
<p>Signal bus connect all submodels with their signal inputs/outputs variables.</p>
</html>",
        revisions="<html>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>Author:</p></td>
<td><p>Marek Matejak</p></td>
</tr>
<tr>
<td><p>License:</p></td>
<td><p><a href=\"http://www.physiomodel.org/license.html\">Physiomodel License 1.0</a> </p></td>
</tr>
<tr>
<td><p>Date of:</p></td>
<td><p>2008-2015</p></td>
</tr>
<tr>
<td><p>References:</p></td>
<td><p>Tom Coleman: HumMod 1.6.1, University of Mississippi Medical Center</p></td>
</tr>
<tr>
<td></td>
<td><p><br><br><br>Siggaard Andersen: OSA (2005), University of Copenhagen</p></td>
</tr>
<tr>
<td></td>
<td><p><br><br><br>Noriaki Ikeda: A model of overall regulation of body fluids (1979), Kitasato University</p></td>
</tr>
</table>
<p><br>Copyright &copy; 2008-2015 Marek Matejak. Charles University in Prague. All rights reserved.</p>
<pre> </pre>
</html>"),
    experiment(StopTime=31536000, Tolerance=1e-005));
end Physiomodel_Main;
