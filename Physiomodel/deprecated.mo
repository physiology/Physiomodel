within Physiomodel;
package deprecated
model ColloidOsmolarity "set osmolarity from protein mass flow"
    extends Physiolibrary.Icons.ConversionIcon;
    Physiolibrary.Types.RealIO.MolarFlowRateInput
                          proteinMassFlow(displayUnit="mmol/min")
                            annotation (Placement(transformation(extent={{-20,80},
              {20,120}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={48,116})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a q_in
      "hydraulic pressure" annotation (Placement(transformation(extent={{-110,-110},
              {-90,-90}}), iconTransformation(extent={{-110,-110},{-90,-90}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out(o(displayUnit="mmol/l"))
      "colloid osmotic pressure" annotation (Placement(transformation(extent={{
              90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

    Physiolibrary.Types.RealIO.PressureOutput
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
     Physiolibrary.Types.RealIO.PressureInput
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
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a q_in(o(displayUnit="mmol/l"))
      "osmolarity"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  //parameter Real C1 =   320.0;
  //parameter Real C2 =   1160.0;
  parameter Physiolibrary.Types.Temperature T=310.15;

  equation
    q_in.q + q_out.q = 0;
    q_out.pressure = hydraulicPressure - q_in.o*Modelica.Constants.R*T;// ( (C1 * q_in.o)  + ( C2 * (q_in.o^2)));

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

  model HydraulicPressure
   extends Physiolibrary.Icons.ConversionIcon;
    Physiolibrary.Types.RealIO.PressureInput
                          hydraulicPressure(displayUnit="mmHg")
                            annotation (Placement(transformation(extent={{-20,80},
              {20,120}}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={40,120})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a q_in(o(displayUnit="mmol/l"))
      "osmoles"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  //parameter Real C1 =   320.0;
  //parameter Real C2 =   1160.0;

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
  end HydraulicPressure;

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

   // parameter Modelica.SIunits.StoichiometricNumber a_in=1 "Stoichiometric number of solute A";
   // parameter Modelica.SIunits.StoichiometricNumber a_out=1 "Stoichiometric number of solute B";
   // parameter Modelica.SIunits.StoichiometricNumber a_out2=1 "Stoichiometric number of solute C";

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

end deprecated;
