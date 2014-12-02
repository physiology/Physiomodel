within Physiomodel;
model Physiomodel_Main "Main model"
  import Physiomodel;
  extends Physiolibrary.Icons.Golem;

Physiomodel.CardioVascular.CVS_Dynamic_OM
                          cardioVascularSystem
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
  Physiomodel.Setup.Setup           setup
    annotation (Placement(transformation(extent={{-10,-92},{10,-72}})));
  Physiomodel.Water.Water_OM
                          water
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
equation

  connect(setup.busConnector, hormones.busConnector) annotation (Line(
      points={{8,-76},{8,27.9},{43.9,27.9}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, proteins.busConnector) annotation (Line(
      points={{8,-76},{8,-3.7},{-31.7,-3.7}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, cardioVascularSystem.busConnector)
                                                annotation (Line(
      points={{8,-76},{8,93.8},{60,93.8}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, nutrientsAndMetabolism.busConnector)
    annotation (Line(
      points={{8,-76},{8,84},{-72,84}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, water.busConnector) annotation (Line(
      points={{8,-76},{8,17},{-69,17}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(setup.busConnector, nerves.busConnector) annotation (Line(
      points={{8,-76},{8,61.6},{76.2,61.6}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(status.busConnector, setup.busConnector)         annotation (Line(
      points={{43.2,-54.8},{8,-54.8},{8,-76}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(electrolytes.busConnector, setup.busConnector) annotation (Line(
      points={{74,-14},{8,-14},{8,-76}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gases.busConnector, setup.busConnector) annotation (Line(
      points={{-58,-42},{8,-42},{8,-76}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(heat.busConnector, setup.busConnector) annotation (Line(
      points={{-28.6,55.6},{8,55.6},{8,-76}},
      color={0,0,255},
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
    experiment(StopTime=1e+008, Tolerance=1e-005));
end Physiomodel_Main;
