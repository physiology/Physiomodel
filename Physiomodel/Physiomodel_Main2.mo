within Physiomodel;
model Physiomodel_Main2 "Main model"
  import Physiomodel;
  extends Physiolibrary.Icons.Golem;

Physiomodel.CardioVascular.CVS_Dynamic
                          cardioVascularSystem
    annotation (Placement(transformation(extent={{46,74},{66,96}})));
  Physiomodel.Metabolism.IO_Bus.InputFromFile_SI   nutrientsAndMetabolism
    annotation (Placement(transformation(extent={{-90,66},{-70,86}})));
  Physiomodel.Electrolytes.IO_Bus.InputFromFile_SI
                                        electrolytes
    annotation (Placement(transformation(extent={{74,-28},{94,-8}})));
  Physiomodel.Hormones.Hormones
                    hormones
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Physiomodel.Nerves.Nerves       nerves
    annotation (Placement(transformation(extent={{74,44},{94,64}})));
  Physiomodel.Setup.IO_Bus.InputFromFile_SI
                                    setup
    annotation (Placement(transformation(extent={{-10,-92},{10,-72}})));
  Physiomodel.Water.IO_Bus.InputFromFile_SI
                           water
    annotation (Placement(transformation(extent={{-86,0},{-66,20}})));
  Physiomodel.Proteins.IO_Bus.InputFromFile_SI
                    proteins
    annotation (Placement(transformation(extent={{-48,-22},{-28,-2}})));
  Physiomodel.Status.TissuesFitness status
    annotation (Placement(transformation(extent={{42,-74},{62,-54}})));
  Physiomodel.Gases.IO_Bus.InputFromFile_SI
                                   gases
    annotation (Placement(transformation(extent={{-76,-60},{-56,-40}})));
  Physiomodel.Heat.Heat2 heat
    annotation (Placement(transformation(extent={{-28,36},{-48,56}})));
  Physiomodel.Heat.IO_Bus.OutputComparison_SI outputComparison_SI
    annotation (Placement(transformation(extent={{-68,36},{-48,56}})));
  Physiomodel.Nerves.IO_Bus.OutputComparison_SI outputComparison_SI1
    annotation (Placement(transformation(extent={{48,42},{68,62}})));
  Physiomodel.Status.IO_Bus.OutputComparison_SI outputComparison_SI2
    annotation (Placement(transformation(extent={{64,-74},{84,-54}})));
  Physiomodel.CardioVascular.IO_Bus.OutputComparison_SI outputComparison_SI3
    annotation (Placement(transformation(extent={{74,74},{94,94}})));
  Physiomodel.Hormones.IO_Bus.OutputComparison_SI outputComparison_SI4
    annotation (Placement(transformation(extent={{64,6},{84,26}})));
equation

  connect(setup.busConnector, hormones.busConnector) annotation (Line(
      points={{0,-82},{0,21.9},{43.9,21.9}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, proteins.busConnector) annotation (Line(
      points={{0,-82},{0,-12},{-38,-12}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, cardioVascularSystem.busConnector)
                                                annotation (Line(
      points={{0,-82},{0,93.8},{48,93.8}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, nutrientsAndMetabolism.busConnector)
    annotation (Line(
      points={{0,-82},{0,76},{-80,76}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, water.busConnector) annotation (Line(
      points={{0,-82},{0,10},{-76,10}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, nerves.busConnector) annotation (Line(
      points={{0,-82},{0,61.6},{76.2,61.6}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(status.busConnector, setup.busConnector)         annotation (Line(
      points={{43.2,-54.8},{0,-54.8},{0,-82}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(electrolytes.busConnector, setup.busConnector) annotation (Line(
      points={{84,-18},{0,-18},{0,-82}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gases.busConnector, setup.busConnector) annotation (Line(
      points={{-66,-50},{0,-50},{0,-82}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heat.busConnector, setup.busConnector) annotation (Line(
      points={{-28.6,55.6},{0,55.6},{0,-82}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heat.busConnector, outputComparison_SI.busConnector) annotation (Line(
      points={{-28.6,55.6},{-48,55.6},{-48,46},{-58,46}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nerves.busConnector, outputComparison_SI1.busConnector) annotation (
      Line(
      points={{76.2,61.6},{68,61.6},{68,52},{58,52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(status.busConnector, outputComparison_SI2.busConnector) annotation (
      Line(
      points={{43.2,-54.8},{58,-54.8},{58,-64},{74,-64}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(cardioVascularSystem.busConnector, outputComparison_SI3.busConnector)
    annotation (Line(
      points={{48,93.8},{84,93.8},{84,84}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(hormones.busConnector, outputComparison_SI4.busConnector) annotation (
     Line(
      points={{43.9,21.9},{74,21.9},{74,16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),      graphics), Documentation(info="<html>
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
<td><p>GPL 3.0</p></td>
</tr>
<tr>
<td><p>By:</p></td>
<td><p>Charles University, Prague</p></td>
</tr>
<tr>
<td><p>Date of:</p></td>
<td><p>2008-2014</p></td>
</tr>
<tr>
<td><p>References:</p></td>
<td><p>Tom Coleman: QHP 2008 beta 3, University of Mississippi Medical Center</p></td>
</tr>
<tr>
<td></td>
<td><p><br>Siggaard Andersen: OSA (2005), University of Copenhagen</p></td>
</tr>
<tr>
<td></td>
<td><p><br>Noriaki Ikeda: A model of overall regulation of body fluids (1979), Kitasato University</p></td>
</tr>
</table>
<br>
<p>Copyright &copy; 2014 Marek Matejak </p>
<br>
<pre>

    This file is part of Physiomodel.

    Physiomodel is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License 3.0 as published by
    the Free Software Foundation.

    Physiomodel is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Physiomodel.  If not, see <a href=\"http://www.gnu.org/licenses/\">http://www.gnu.org/licenses/</a>.</pre>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),
        graphics),
    experiment(
      StopTime=3.1536e+007,
      NumberOfIntervals=200,
      Tolerance=0.01),
    experimentSetupOutput,
    Commands(file="view.mos" "view"));
end Physiomodel_Main2;
