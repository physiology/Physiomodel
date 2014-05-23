within Physiomodel;
package deprecated

  constant Real SecPerMin(unit="min/s")=60;

  model ConcentrationMeasure
    parameter String unitsString="";
    parameter Real toAnotherUnitCoef=1;

    Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in annotation (Placement(
          transformation(extent={{-120,-20},{-80,20}}), iconTransformation(
            extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.RealOutput actualConc
                           annotation (Placement(transformation(extent={{-20,30},{20,70}}),
          iconTransformation(extent={{-20,-20},{20,20}},
                                                       rotation=90,
          origin={0,40})));
  equation

    actualConc =             toAnotherUnitCoef * q_in.conc;   //TODO: standard units
                  /*toAnotherUnitCoef */
    q_in.q = 0;
   annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={Text(
            extent={{-48,-24},{48,-40}},
            lineColor={0,0,0},
            textString="%unitsString"), Rectangle(
            extent={{-20,20},{20,-20}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
                                    Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end ConcentrationMeasure;

  model MolarConcentrationCompartment
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;
    extends Physiolibrary.Icons.Substance;

    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (
        Placement(transformation(extent={{62,-32},{102,8}}), iconTransformation(
            extent={{-10,-10},{10,10}})));
    parameter Real initialSoluteMass;

    Modelica.Blocks.Interfaces.RealInput SolventVolume(
                                                      final quantity="Volume",
        final displayUnit="ml")     annotation (Placement(transformation(extent={{-120,68},{-80,108}}),
          iconTransformation(extent={{-100,40},{-60,80}})));
    Modelica.Blocks.Interfaces.RealOutput soluteMass(
                                                    start=initialSoluteMass)
      annotation (Placement(transformation(extent={{-20,-120},{20,-80}}, rotation=
             -90,
          origin={102,-102}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,-78})));                                                 //, min=0)
  //initial equation
  //  soluteMass = initialSoluteMass;
  equation
    //assert(soluteMass>=0,"Solute mass has to be positive value!");
      q_out.conc = if (SolventVolume>0) then soluteMass / SolventVolume else 0;
  //  q_out.conc = if initial() or (SolventVolume>0) then soluteMass / SolventVolume else 0;
  //  der(soluteMass) = q_out.q / Library.SecPerMin;
    state = soluteMass;

    change = q_out.q/60;  //TODO: not change per min
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
          graphics={                                    Text(
            extent={{-22,-102},{220,-136}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end MolarConcentrationCompartment;

  model PressureControledCompartment
    "Multiple PressureFlow connector with pressures from multiple inputs"
   extends Physiolibrary.SteadyStates.Interfaces.SteadyState;

    Modelica.Blocks.Interfaces.RealInput
                          pressure(final quantity="Pressure", final displayUnit=
        "mmHg") "Pressure value input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a y
      "PressureFlow output connectors" annotation (Placement(transformation(
            extent={{100,-20},{140,20}}, rotation=0), iconTransformation(extent
            ={{-120,-20},{-80,20}})));

    parameter Real initialVolume;
    Modelica.Blocks.Interfaces.RealOutput
                           Volume(start=initialVolume, final quantity="Volume", final unit =                    "ml")
      annotation (Placement(transformation(extent={{-20,-120},{20,-80}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,-100})));

  //initial equation
  //  Volume = initialVolume;
   // der(Volume) = 0;
  equation
  /*  if STEADY then
      der(Volume) = 0;
  else
      der(Volume) = (ones(ncon)*y.q)/Library.SecPerMin;
  end if;
*/

    y.pressure = pressure;

    state = Volume;
    change = y.q/60;

    annotation (Documentation(info="<html>
<p>Model has a vector of continuous Real input signals as pressures for vector of pressure-flow connectors. </p>
<p>Usage in tests: Set defaul volume&GT;0 and try to set STEADY in instances to &QUOT;false&QUOT;!</p>
</html>",
     revisions=
       "<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
                      graphics));
  end PressureControledCompartment;

  model VolumeCompartement
    "Generate constant pressure independ on inflow or outflow"
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;

    parameter Real pressure=0;

    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a con annotation (
        Placement(transformation(extent={{100,-20},{140,20}}, rotation=0),
          iconTransformation(extent={{-120,-20},{-80,20}})));

    parameter Real initialVolume;

    Modelica.Blocks.Interfaces.RealOutput
                           Volume(start=initialVolume) annotation (Placement(transformation(extent={{
              -8,-120},{32,-80}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={12,-100})));
  //initial equation
  //  Volume = initialVolume;
  equation
    /*if STEADY then
    der(Volume) = 0;
  else
    der(Volume) = con.q/Library.SecPerMin;
  end if;
*/
    /*if Volume<=0 and con.q<=0 then
    der(Volume) = 0;
  else
    con.pressure = pressure;
  end if;
 */
    if Volume>0 or con.q>0 then
              con.pressure = pressure;
            else
              con.q = 0;
            end if;

    state = Volume;
    change = con.q/60;
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),
      graphics,
            lineColor={0,0,0}), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid));
  end VolumeCompartement;

  model MassStorageCompartment
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;
     extends Physiolibrary.Icons.Substance;

    parameter Real MINUTE_FLOW_TO_MASS_CONVERSION = 1
      "this constant will multiply the flow inside integration to mass";

    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (
        Placement(transformation(extent={{62,-32},{102,8}}), iconTransformation(
            extent={{-10,-10},{10,10}})));
    parameter Real initialSoluteMass;

    Modelica.Blocks.Interfaces.RealOutput soluteMass(
                                                    start=initialSoluteMass)
      annotation (Placement(transformation(extent={{-14,-120},{26,-80}},rotation=-90,
          origin={0,2}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,-74})));

  //initial equation
  //  soluteMass = initialSoluteMass;
  equation
    q_out.conc = soluteMass;
    //der(soluteMass) = q_out.q / Library.SecPerMin;

    state = soluteMass;
    change = q_out.q * MINUTE_FLOW_TO_MASS_CONVERSION/60;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
          graphics={                      Text(
            extent={{-94,134},{98,106}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end MassStorageCompartment;

  model MassConcentrationCompartment
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;
     extends Physiolibrary.Icons.Substance;
    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (
        Placement(transformation(extent={{62,-32},{102,8}}), iconTransformation(
            extent={{-10,-10},{10,10}})));
    parameter Real initialSoluteMass;

    Modelica.Blocks.Interfaces.RealInput SolventVolume(
                                                      final quantity="Volume",
        final displayUnit="ml")     annotation (Placement(transformation(extent={{-120,68},{-80,108}}),
          iconTransformation(extent={{-100,40},{-60,80}})));
    Modelica.Blocks.Interfaces.RealOutput soluteMass(
                                                    start=initialSoluteMass)
      annotation (Placement(transformation(extent={{-20,-120},{20,-80}}, rotation=
             -90,
          origin={102,-102}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,-78})));                                                 //, min=0)
  //initial equation
  //  soluteMass = initialSoluteMass;
  equation
    //assert(soluteMass>=0,"Solute mass has to be positive value!");
      q_out.conc = if (SolventVolume>0) then soluteMass / SolventVolume else 0;
  //  q_out.conc = if initial() or (SolventVolume>0) then soluteMass / SolventVolume else 0;
  //  der(soluteMass) = q_out.q / Library.SecPerMin;
    state = soluteMass;

    change = q_out.q/60;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
          graphics={                                    Text(
            extent={{-22,-102},{220,-136}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end MassConcentrationCompartment;

  model MolarStorageCompartment
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;
   extends Physiolibrary.Icons.Substance;

    parameter Real MINUTE_FLOW_TO_MASS_CONVERSION = 1
      "this constant will multiply the flow inside integration to mass";

    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (
        Placement(transformation(extent={{62,-32},{102,8}}), iconTransformation(
            extent={{-10,-10},{10,10}})));
    parameter Real initialSoluteMass;

    Modelica.Blocks.Interfaces.RealOutput soluteMass(
                                                    start=initialSoluteMass)
      annotation (Placement(transformation(extent={{-14,-120},{26,-80}},rotation=-90,
          origin={0,2}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,-74})));

  //initial equation
  //  soluteMass = initialSoluteMass;
  equation
    q_out.conc = soluteMass;
    //der(soluteMass) = q_out.q / Library.SecPerMin;

    state = soluteMass;
    change = q_out.q * MINUTE_FLOW_TO_MASS_CONVERSION/60;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
          graphics={                      Text(
            extent={{-94,134},{98,106}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end MolarStorageCompartment;

  model WaterColloidOsmoticCompartment
    extends Physiolibrary.SteadyStates.Interfaces.SteadyState;

    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out(o(final displayUnit=
            "g/ml")) annotation (Placement(transformation(extent={{62,-32},{102,
              8}}), iconTransformation(extent={{-10,-10},{10,10}})));
    parameter Real initialWaterVolume(final quantity="Volume", displayUnit="ml");

    Modelica.Blocks.Interfaces.RealInput NotpermeableSolutes(
                                                            quantity="Mass",
        displayUnit="g")   annotation (Placement(transformation(extent={{-120,60},
              {-80,100}}),
          iconTransformation(extent={{-120,60},{-80,100}})));
    Modelica.Blocks.Interfaces.RealOutput WaterVolume(
      start=initialWaterVolume,
      final quantity="Volume",
      displayUnit="ml")
      annotation (Placement(transformation(extent={{-20,-120},{20,-80}}, rotation=
             -90)));

  //initial equation
  //  WaterVolume = initialWaterVolume;
  equation
    q_out.o = if (WaterVolume>0) then NotpermeableSolutes / WaterVolume else 0;

    change = q_out.q/60;
    state = WaterVolume;
  //  der(WaterVolume) = q_out.q / Library.SecPerMin;
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                 graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end WaterColloidOsmoticCompartment;

  model PartialPressure
    "partial gas concentration in ml/ml multiplied by ambient pressure"

    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b outflow annotation (
        Placement(transformation(extent={{-20,-120},{20,-80}}),
          iconTransformation(extent={{-10,-110},{10,-90}})));
    Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in annotation (Placement(
          transformation(extent={{-20,80},{20,120}}), iconTransformation(extent
            ={{-10,90},{10,110}})));
    Modelica.Blocks.Interfaces.RealInput
                          ambientPressure annotation (Placement(transformation(extent={{
              -60,-20},{-20,20}}), iconTransformation(extent={{-60,-20},{-20,20}})));
  equation
    q_in.q+outflow.q=0;
    outflow.pressure=q_in.conc*ambientPressure;
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-40,100},{40,-100}},
            lineColor={0,0,255},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end PartialPressure;

  model OsmoticPump "Defined osmoles to/from/in system by real signal"
    extends Physiolibrary.Osmotic.Interfaces.OnePort;
    Modelica.Blocks.Interfaces.RealInput
                          desiredOsmoles(quantity="Osmolarity", displayUnit="mOsm")
      "desired pressure flow value"                                                                  annotation (Placement(transformation(
            extent={{-66,50},{-26,90}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,60})));

  equation
    q_in.o = desiredOsmoles;
   annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-80,60},{80,-60}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,25},{80,0},{-80,-25},{-80,25}},
            lineColor={255,170,170},
            fillColor={255,170,170},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,-94},{150,-54}},
            textString="%name",
            lineColor={0,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={255,170,170}),
          Text(
            extent={{-36,-72},{-152,98}},
            lineColor={255,170,170},
            fillColor={255,170,170},
            fillPattern=FillPattern.Solid,
            textString="")}), Diagram(coordinateSystem(preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}}), graphics));
  end OsmoticPump;

  model ColloidOsmolarity "set osmolarity from protein mass flow"
    extends Physiolibrary.Icons.ConversionIcon;
    Modelica.Blocks.Interfaces.RealInput
                          proteinMassFlow(displayUnit="g/min")
                            annotation (Placement(transformation(extent={{-20,80},
              {20,120}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={48,116})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a q_in
      "hydraulic pressure" annotation (Placement(transformation(extent={{-110,-110},
              {-90,-90}}), iconTransformation(extent={{-110,-110},{-90,-90}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out(o(displayUnit="g/ml"))
      "colloid osmotic pressure" annotation (Placement(transformation(extent={{
              90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  parameter Real C1 =   320.0;
  parameter Real C2 =   1160.0;

    Modelica.Blocks.Interfaces.RealOutput
                           P annotation (Placement(transformation(extent={{42,86},
              {82,126}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={-60,-120})));
  equation
    q_in.q + q_out.q = 0;
    q_out.o = abs(proteinMassFlow/q_in.q);
    P = q_in.pressure;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}},
          initialScale=0.04), graphics={Text(
            extent={{22,92},{84,18}},
            lineColor={0,0,0},
            textString="O"), Text(
            extent={{-94,-12},{-10,-90}},
            lineColor={0,0,0},
            textString="P")}), Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.04), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end ColloidOsmolarity;

  model ColloidHydraulicPressure
    "set pressure as sum of osmotic pressure(from osmoles) and hydrostatic/hydrodynamic pressure(from signal)"
    extends Physiolibrary.Icons.ConversionIcon;
    Modelica.Blocks.Interfaces.RealInput
                          hydraulicPressure(displayUnit="mmHg")
                            annotation (Placement(transformation(extent={{-20,80},
              {20,120}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={40,120})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b q_out
      "pressure on semipermeable membrane wall = osmotic + hydrostatic"
      annotation (Placement(transformation(extent={{90,-10},{110,10}}),
          iconTransformation(extent={{90,-10},{110,10}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a q_in(o(displayUnit="g"))
      "osmoles"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  parameter Real C1 =   320.0;
  parameter Real C2 =   1160.0;

  equation
    q_in.q + q_out.q = 0;
    q_out.pressure = hydraulicPressure - ( (C1 * q_in.o)  + ( C2 * (q_in.o^2)));

    annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}},
          initialScale=0.04), graphics={Text(
            extent={{-94,-10},{-32,-84}},
            lineColor={0,0,0},
            textString="O"), Text(
            extent={{8,92},{92,14}},
            lineColor={0,0,0},
            textString="P")}), Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.04), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end ColloidHydraulicPressure;

  model ColloidHydraulicPressure0
   extends Physiolibrary.Icons.ConversionIcon;
    Modelica.Blocks.Interfaces.RealInput
                          hydraulicPressure(displayUnit="mmHg")
                            annotation (Placement(transformation(extent={{-20,80},
              {20,120}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={40,120})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a q_in(o(displayUnit="g"))
      "osmoles"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  parameter Real C1 =   320.0;
  parameter Real C2 =   1160.0;

    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b withoutCOP
      "only hydrostatic pressure without colloid osmotic pressure" annotation (
        Placement(transformation(extent={{90,90},{110,110}}),
          iconTransformation(extent={{90,90},{110,110}})));

  equation
    q_in.q + withoutCOP.q = 0;
    withoutCOP.pressure = hydraulicPressure;

    annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
              -100},{100,100}},
          initialScale=0.04), graphics={Text(
            extent={{-94,-10},{-32,-84}},
            lineColor={0,0,0},
            textString="O"), Text(
            extent={{8,92},{92,14}},
            lineColor={0,0,0},
            textString="P")}), Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          initialScale=0.04), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end ColloidHydraulicPressure0;

  model MolarOutflux "Molar pump of solute"

    Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in "Inflow" annotation (
        extent=[-10,-110; 10,-90], Placement(transformation(extent={{-110,-8},{
              -90,12}}), iconTransformation(extent={{-70,-10},{-50,10}})));
    Physiolibrary.Types.RealIO.MolarFlowRateInput desiredFlow
      "Solute flow rate" annotation (extent=[-10,30; 10,50], rotation=-90);

  equation
    q_in.q = desiredFlow;

   annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-60,-32},{60,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-48,18},{50,-2},{-48,-26},{-48,18}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-78,-54},{72,-32}},
            textString="%name",
            lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end MolarOutflux;

  model MassOutputPump

    Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in annotation (extent=[-10,
          -110; 10,-90], Placement(transformation(extent={{-110,-8},{-90,12}}),
          iconTransformation(extent={{-70,-10},{-50,10}})));
    Modelica.Blocks.Interfaces.RealInput desiredFlow
                                   annotation ( extent = [-10,30;10,50], rotation = -90);

  equation
    q_in.q = desiredFlow;

   annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-60,-32},{60,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-48,18},{50,-2},{-48,-26},{-48,18}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-78,-54},{72,-32}},
            textString="%name",
            lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end MassOutputPump;

  model ContinualReaction "Continual flow reaction of type  a A <-> b B"

    Physiolibrary.Chemical.Interfaces.ChemicalPort_a A "solute A" annotation (
        Placement(transformation(extent={{-120,-20},{-80,20}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));
    Physiolibrary.Chemical.Interfaces.ChemicalPort_b B "solute B" annotation (
        extent=[-10,-110; 10,-90], Placement(transformation(extent={{90,20},{
              110,40}}), iconTransformation(extent={{90,20},{110,40}})));

    parameter Modelica.SIunits.StoichiometricNumber a=1
      "Stoichiometric number of solute A";
    parameter Modelica.SIunits.StoichiometricNumber b=1
      "Stoichiometric number of solute B";

  equation
     a*A.q + b*B.q = 0;
     a*A.conc = b*B.conc;  // sound strange, dissociation constand should be here
   annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-100,-28},{100,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-128,-60},{142,-34}},
            textString="%name",
            lineColor={0,0,255}),
          Polygon(
            points={{-60,4},{-60,2},{54,2},{54,2},{18,12},{18,4},{-60,4}},
            lineColor={0,0,0},
            smooth=Smooth.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
                                    Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end ContinualReaction;

  model ContinualReaction2
    "Continual flow reaction of type  a A <-> b B + c C, where the concentration of C does not play the role"

    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out annotation (extent=[
          -10,-110; 10,-90], Placement(transformation(extent={{90,20},{110,40}}),
          iconTransformation(extent={{90,20},{110,40}})));
    Modelica.Blocks.Interfaces.RealInput coef
      "who much units of q_out produce one unit of q_in"
                                  annotation ( extent = [-10,30;10,50], rotation = -90);

    Physiolibrary.Chemical.Interfaces.ChemicalPort_a q_in annotation (Placement(
          transformation(extent={{-120,-20},{-80,20}}), iconTransformation(
            extent={{-110,-10},{-90,10}})));
    Physiolibrary.Chemical.Interfaces.ChemicalPort_b q_out2 annotation (extent=
          [-10,-110; 10,-90], Placement(transformation(extent={{90,-10},{110,10}}),
          iconTransformation(extent={{90,-40},{110,-20}})));
    Modelica.Blocks.Interfaces.RealInput
                          coef2
      "who much units of q_out2 produce one unit of q_in"                           annotation (Placement(transformation(extent={{-54,
              20},{-14,60}}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={60,40})));

    parameter Modelica.SIunits.StoichiometricNumber a_in=1
      "Stoichiometric number of solute A";
    parameter Modelica.SIunits.StoichiometricNumber a_out=1
      "Stoichiometric number of solute B";
    parameter Modelica.SIunits.StoichiometricNumber a_out2=1
      "Stoichiometric number of solute C";

  equation
    q_out.q + coef*q_in.q = 0;
    q_out2.q + coef2*q_in.q = 0;
    q_out.conc = coef*q_in.conc;
   annotation (
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics={
          Rectangle(
            extent={{-100,-30},{100,30}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-128,-66},{142,-40}},
            textString="%name",
            lineColor={0,0,255}),
          Polygon(
            points={{-60,4},{-60,2},{54,2},{54,2},{18,12},{18,4},{-60,4}},
            lineColor={0,0,0},
            smooth=Smooth.None,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
                                    Diagram(coordinateSystem(preserveAspectRatio=true,
                     extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"),      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics));
  end ContinualReaction2;

  model Input2EffectDelayed
    "adapt the value of multiplication coeficient calculated from curve"
   extends Physiolibrary.Icons.BaseFactorIcon3;
   Modelica.Blocks.Interfaces.RealInput u
                annotation (Placement(transformation(extent={{-118,44},{-78,
              84}}),
          iconTransformation(extent={{-108,-10},{-88,10}})));
   parameter Real HalfTime(unit="s", displayUnit="d"); //Tau(unit="day");
   parameter Real[:,3] data;
   parameter String stateName;
    Physiolibrary.Blocks.Interpolation.Curve curve(
      x=data[:, 1],
      y=data[:, 2],
      slope=data[:, 3])
      annotation (Placement(transformation(extent={{-68,58},{-48,78}})));
    Modelica.Blocks.Math.Product product annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,-32})));
    Physiolibrary.Blocks.Math.Integrator integrator(
      y_start=1,
      stateName=stateName,
      k=(1/((HalfTime/Modelica.Math.log(2))*1440))/SecPerMin) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-26,12})));
    Modelica.Blocks.Math.Feedback feedback annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-26,44})));
    Real effect;
  equation
    effect = integrator.y;
    connect(curve.u, u) annotation (Line(
        points={{-68,68},{-83,68},{-83,64},{-98,64}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(yBase, product.u1) annotation (Line(
        points={{6,80},{6,30},{6,-20},{6,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(product.y, y) annotation (Line(
        points={{-2.02067e-015,-43},{-2.02067e-015,-55.5},{0,-55.5},{0,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(curve.val, feedback.u1) annotation (Line(
        points={{-47.8,68},{-26,68},{-26,52}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.y, integrator.u) annotation (Line(
        points={{-26,35},{-26,29.5},{-26,24},{-26,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, feedback.u2) annotation (Line(
        points={{-26,1},{-26,-8},{-50,-8},{-50,44},{-34,44}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, product.u2) annotation (Line(
        points={{-26,1},{-26,-8},{-6,-8},{-6,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end Input2EffectDelayed;

  model DelayedInput2Effect
    "adapt the signal, from which is by curve multiplication coeficient calculated"
   extends Physiolibrary.Icons.BaseFactorIcon5;
   Modelica.Blocks.Interfaces.RealInput u
                annotation (Placement(transformation(extent={{-118,44},{-78,
              84}}),
          iconTransformation(extent={{-108,-10},{-88,10}})));
   parameter Real HalfTime(unit="s", displayUnit="min") = 3462.468; //40*60/Modelica.Math.log(2);
   parameter Real initialValue = 1; //40;
   parameter Real[:,3] data;
   parameter String adaptationSignalName;
    Physiolibrary.Blocks.Interpolation.Curve curve(
      x=data[:, 1],
      y=data[:, 2],
      slope=data[:, 3])
      annotation (Placement(transformation(extent={{-38,-16},{-18,4}})));
    Modelica.Blocks.Math.Product product annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,-32})));
    Physiolibrary.Blocks.Math.Integrator integrator(
      y_start=initialValue,
      stateName=adaptationSignalName,
      k=(1/(HalfTime/Modelica.Math.log(2)))/SecPerMin) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-60,16})));
    Modelica.Blocks.Math.Feedback feedback annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-60,46})));
    Real effect;
  equation
    effect = curve.val;
    connect(yBase, product.u1) annotation (Line(
        points={{6,80},{6,30},{6,-20},{6,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(product.y, y) annotation (Line(
        points={{-2.02067e-015,-43},{-2.02067e-015,-55.5},{0,-55.5},{0,-60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.y, integrator.u) annotation (Line(
        points={{-60,37},{-60,28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, feedback.u2) annotation (Line(
        points={{-60,5},{-60,-6},{-84,-6},{-84,46},{-68,46}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.u1, u) annotation (Line(
        points={{-60,54},{-60,64},{-98,64}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, curve.u) annotation (Line(
        points={{-60,5},{-60,-6},{-38,-6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(curve.val, product.u2) annotation (Line(
        points={{-17.8,-6},{-6,-6},{-6,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>",
        info="<html>
<p>If the input signal u is constant and it is different from starting delayed input d, the midle value between u and d will be reached after HalfTime.</p>
<p>The mathematical background:</p>
<p>d&apos;(t) = k*(u(t) - d(t))       =&GT;       The solution of d(t) in special case, if u(t) is constant at each time t:  d(t)=u+(d(0)-u)*e^(-k*t),  where the definition of HalfTime is  d(HalfTime) = d(0) + (d(0)-u)/2.</p>
</html>"));
  end DelayedInput2Effect;

  model Input2EffectDelayedOrZero
    "combination of SplineDelayByDay and ZeroIfFalse"
   extends Physiolibrary.Icons.BaseFactorIcon2;
   Modelica.Blocks.Interfaces.RealInput u
                annotation (Placement(transformation(extent={{-118,6},{-78,46}}),
          iconTransformation(extent={{-108,-30},{-88,-10}})));
   parameter Real  HalfTime(unit="s", displayUnit="d");
   parameter Real[:,3] data;
    parameter String stateName;
    Physiolibrary.Blocks.Interpolation.Curve curve(
      x=data[:, 1],
      y=data[:, 2],
      slope=data[:, 3])
      annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
    Modelica.Blocks.Math.Product product annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,-50})));
    Physiolibrary.Blocks.Math.Integrator integrator(
      y_start=1,
      stateName=stateName,
      k=(1/((HalfTime/Modelica.Math.log(2))*1440))/SecPerMin) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-14,-6})));
    Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-14,26})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-36,40},{-16,60}})));
    Physiolibrary.Types.Constants.DeprecatedUntypedConstant Constant1(k=0)
      annotation (Placement(transformation(extent={{-82,62},{-62,82}})));
    Modelica.Blocks.Interfaces.BooleanInput
                                          Failed
                        annotation (Placement(transformation(extent={{-118,30},{
              -78,70}}), iconTransformation(extent={{-108,30},{-88,50}})));
    Real effect;
  equation
    effect = integrator.y;
    connect(curve.u, u) annotation (Line(
        points={{-76,30},{-87,30},{-87,26},{-98,26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(yBase, product.u1) annotation (Line(
        points={{6,100},{6,31},{6,-38},{6,-38}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(product.y, y) annotation (Line(
        points={{-2.02067e-015,-61},{-2.02067e-015,-55.5},{0,-55.5},{0,-80}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.y, integrator.u) annotation (Line(
        points={{-14,17},{-14,14.25},{-14,14.25},{-14,11.5},{-14,11.5},{-14,6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, feedback.u2) annotation (Line(
        points={{-14,-17},{-14,-26},{-38,-26},{-38,26},{-22,26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(integrator.y, product.u2) annotation (Line(
        points={{-14,-17},{-14,-26},{-6,-26},{-6,-38}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(switch1.y, feedback.u1) annotation (Line(
        points={{-15,50},{-14,50},{-14,34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(curve.val, switch1.u3) annotation (Line(
        points={{-55.8,30},{-54,30},{-54,42},{-38,42}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(Constant1.y, switch1.u1) annotation (Line(
        points={{-61,72},{-58,72},{-58,58},{-38,58}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(switch1.u2, Failed) annotation (Line(
        points={{-38,50},{-98,50}},
        color={255,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=true,  extent={{-100,-100},{100,100}}), graphics),
      Documentation(revisions="<html>
<p><i>2009-2010</i></p>
<p>Marek Matejak, Charles University, Prague, Czech Republic </p>
</html>"));
  end Input2EffectDelayedOrZero;

  model ResistorWith2Cond
    "Because of problem with its middle pressure initialization"

    Physiolibrary.Types.RealIO.HydraulicConductanceInput cond1
      "First conductance" annotation (Placement(transformation(extent={{-66,50},
              {-26,90}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={200,40})));
    Physiolibrary.Types.RealIO.HydraulicConductanceInput cond2
      "Second conductance" annotation (Placement(transformation(extent={{-66,50},
              {-26,90}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,40})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a q_in "Volume inflow"
      annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b q_out "Volume outflow"
      annotation (extent=[-10,-110; 10,-90], Placement(transformation(extent={{
              92,-10},{112,10}}), iconTransformation(extent={{290,-10},{310,10}})));
  equation
    q_in.q + q_out.q = 0;
    q_in.q = cond1*cond2/(cond1+cond2) * (q_in.pressure - q_out.pressure);
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
              {300,100}}),
                     graphics={Text(
            extent={{-100,-100},{300,-40}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{130,30},{270,-30}},
            lineColor={0,0,0},
            fillColor={241,241,241},
            fillPattern=FillPattern.Solid),
          Line(points={{110,0},{130,0}}, color={0,0,0}),
          Line(points={{270,0},{290,0}},
                                       color={0,0,0}),
          Rectangle(
            extent={{-70,30},{70,-30}},
            lineColor={0,0,0},
            fillColor={241,241,241},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{130,0}},color={0,0,0})}), Diagram(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{300,100}})));
  end ResistorWith2Cond;
end deprecated;
