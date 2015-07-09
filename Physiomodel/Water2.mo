within Physiomodel;
package Water2 "Body Water"
  extends Physiolibrary.Icons.WaterLib;
  package Hydrostatics
    "Hydrostatic pressure difference in upper, midle and lower torso"

  block Constant "Generate constant signal of type Posture"
    parameter Posture k=Posture.Lying "Constant output value";

    PostureOutput y "Connector of Real output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

  equation
    y = k;

    annotation (
      Icon(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}},
      grid={2,2},
      initialScale=0.04), graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillPattern=FillPattern.Solid,
              fillColor={255,255,255}), Text(
              extent={{-100,-40},{100,46}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="%k")}),
      Diagram(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}},
      grid={2,2},
      initialScale=0.04), graphics={Text(
              extent={{-100,-100},{100,100}},
              lineColor={0,0,0},
              textString="%k")}),
  Documentation(info="<html>
<p>
The Real output y is a constant signal:
</p>
</html>"));
  end Constant;

    type Posture = enumeration(
        Lying,
        Sitting,
        Standing,
        Tilting,
        SteadyState);

    model TorsoHydrostatics

       parameter Physiolibrary.Types.Fraction Alpha =   0.1667
        "torso: capilary pressure coeficient between artery and vein pressure";
       parameter Physiolibrary.Types.Acceleration GravityAcceleration = 9.81
        "gravity constant";
       parameter Physiolibrary.Types.Density BloodDensity = 1060
        "blood density";

       parameter Physiolibrary.Types.Position TorsoHeight
        "torso: center of gravity - height";

       parameter Physiolibrary.Types.Fraction artyFractGz[Posture]
        "torso: arty hydrostatic effects for posturing";
       parameter Physiolibrary.Types.Fraction veinFractGz[Posture]
        "torso: vein hydrostatic effects for posturing";

       Physiolibrary.Types.Fraction ArtyFractGz;
       Physiolibrary.Types.Fraction VeinFractGz;
       Physiolibrary.Types.Pressure TorsoArtyGradient;
       Physiolibrary.Types.Pressure TorsoVeinGradient;
       Physiolibrary.Types.Pressure Arty;
       Physiolibrary.Types.Pressure Vein;

      Physiolibrary.Types.RealIO.FractionInput
                                         Pump_Effect "xNormal"
                                               annotation (Placement(transformation(extent={{
                -120,-100},{-80,-60}}), iconTransformation(extent={{-120,-100},{-80,
                -60}})));
      Physiolibrary.Types.RealIO.PressureInput
                                         fromPressure
        "torso: systemic arteries pressure"                             annotation (Placement(transformation(extent={{
                -120,0},{-80,40}}), iconTransformation(extent={{-120,0},{-80,40}})));
      Physiolibrary.Types.RealIO.PressureInput
                                         toPressure
        "torso: systemic veins pressure"                                   annotation (Placement(transformation(extent={{-120,
                -40},{-80,0}}),       iconTransformation(extent={{-120,-40},{-80,0}})));
      PostureInput Status_Posture "Lying, Sitting, Standing or Tilting"           annotation (Placement(transformation(
              extent={{-120,60},{-80,100}}), iconTransformation(extent={{-120,60},{
                -80,100}})));
      Physiolibrary.Types.RealIO.PressureOutput Capy
        "torso: average capilaries pressure"                                                      annotation (Placement(transformation(extent={{80,-20},
                {120,20}}), iconTransformation(extent={{80,-20},{120,20}})));
    equation
       ArtyFractGz = artyFractGz[Status_Posture];
       VeinFractGz = veinFractGz[Status_Posture]; //in legs veins are valves

       TorsoArtyGradient  =  TorsoHeight * GravityAcceleration * BloodDensity * ArtyFractGz;  //Hydrostatic pressure: P=ro.g.h
       //cm *  0.01 m/cm * 9.81 m/s² * 1060 kg/m3 * 1/133.322 mmHg/Pa
       //= height[cm] * 0.77996129671022036873134216408395 [mmHg]
       //Blood density = 1060 kg/m3: Cutnell, John & Johnson, Kenneth. Physics, Fourth Edition. Wiley, 1998: 308.

       //bloodDensity = 1060 kg/m3
       //gravityAcceleration = 9.81 m/s2
       //Pa2mmHg = 1/133.322 mmHg/Pa
       //cm2m = 0.01 m/cm
       //averageHydrostaticHeight = TorsoCM * postureCoef[Status_Posture]
       //hydrostaticPressure = averageHydrostaticHeight * cm2m * bloodDensity * gravityAcceleration * Pa2mmHg
       //                    = 0.77996 * averageHydrostaticHeight

       TorsoVeinGradient  =  TorsoHeight * GravityAcceleration * BloodDensity * VeinFractGz;

       Arty  = max( (fromPressure + TorsoArtyGradient), 0);
       Vein  = max( toPressure + ( TorsoVeinGradient * Pump_Effect), 0);  //only lower torso has LegMusclePump_Effect
       Capy  = max( ( Alpha * Arty)   + ( 1.0 - Alpha)  * Vein, 0);

     annotation (
    Documentation(info="<HTML>
<PRE>
QHP 2008 / Hydrostatics
 
Created : 18-Jun-05
Last Modified : 18-Jun-05
Author : Tom Coleman
Copyright Status : In Public Domain
Solver : QHP 2008
Schema : 2008.0
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics), Diagram(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics));
    end TorsoHydrostatics;

    model Hydrostatics
      extends Physiolibrary.Icons.Hydrostatics;

       parameter Real TiltTable_Degrees( final quantity="Angle", final displayUnit="Deg")= 0;

      TorsoHydrostatics UpperTorsoHydrostatics(
        artyFractGz={0,1,1,sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),1.76947},
        veinFractGz={0,1,1,sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),1.76947},
        TorsoHeight=-0.1)
        annotation (Placement(transformation(extent={{-12,34},{16,62}})));

      TorsoHydrostatics LowerTorsoHydrostatics(
        artyFractGz={0,0.7,1,sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),0.0190301},
        veinFractGz={0.2,0.7,1,0.2 + sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),0.0190301},
        TorsoHeight=0.5)
        annotation (Placement(transformation(extent={{-12,-42},{16,-14}})));

      TorsoHydrostatics MiddleTorsoHydrostatics(
        artyFractGz={0,1,1,sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),-0.00024891},
        veinFractGz={0,1,1,sin(Modelica.SIunits.Conversions.from_deg(
            TiltTable_Degrees)),-0.00024891},
        TorsoHeight=0.04)
        annotation (Placement(transformation(extent={{-12,-4},{16,24}})));

    Physiolibrary.Types.Constants.FractionConst             PumpEffect(k=1)
      annotation (Placement(transformation(extent={{-40,32},{-36,36}})));
      Physiolibrary.Types.RealIO.PressureInput
                                         SystemicArtys_Pressure
        annotation (Placement(transformation(extent={{-44,56},{-40,60}}),
            iconTransformation(extent={{-100,-30},{-80,-10}})));
      Physiolibrary.Types.RealIO.PressureInput
                                         RightAtrium_Pressure
        annotation (Placement(transformation(extent={{-34,66},{-30,70}}),
            iconTransformation(extent={{-100,10},{-80,30}})));
      Physiolibrary.Types.RealIO.FractionInput
                                         LegMusclePump_Effect
        annotation (Placement(transformation(extent={{-46,-42},{-38,-34}}),
            iconTransformation(extent={{-100,-90},{-80,-70}})));
      Modelica.Blocks.Interfaces.RealInput Status_Posture
        "Lying, Sitting, Standing or Tilting"                                   annotation (Placement(transformation(
              extent={{-90,22},{-86,26}}), iconTransformation(extent={{-100,70},{-80,
                90}})));
      Physiolibrary.Types.RealIO.PressureOutput
                                          RegionalPressure_UpperCapy
                                              annotation (Placement(transformation(
              extent={{42,44},{50,52}}),     iconTransformation(extent={{90,20},{
                110,40}})));
      Physiolibrary.Types.RealIO.PressureOutput
                                          RegionalPressure_MiddleCapy
                                              annotation (Placement(transformation(
              extent={{42,6},{50,14}}),      iconTransformation(extent={{90,-20},{
                110,0}})));
      Physiolibrary.Types.RealIO.PressureOutput
                                          RegionalPressure_LowerCapy
                                              annotation (Placement(transformation(
              extent={{42,-32},{50,-24}}),   iconTransformation(extent={{90,-60},{
                110,-40}})));
      Real2Posture real2Posture
        annotation (Placement(transformation(extent={{-72,20},{-64,28}})));
    equation
      connect(RightAtrium_Pressure,LowerTorsoHydrostatics. toPressure) annotation (
          Line(
          points={{-32,68},{-28,68},{-28,-30.8},{-12,-30.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RightAtrium_Pressure,MiddleTorsoHydrostatics. toPressure) annotation (
         Line(
          points={{-32,68},{-28,68},{-28,7.2},{-12,7.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RightAtrium_Pressure,UpperTorsoHydrostatics. toPressure) annotation (
          Line(
          points={{-32,68},{-28,68},{-28,45.2},{-12,45.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(PumpEffect.y,UpperTorsoHydrostatics. Pump_Effect) annotation (Line(
          points={{-35.5,34},{-26,34},{-26,36.8},{-12,36.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(MiddleTorsoHydrostatics.Pump_Effect,PumpEffect. y) annotation (Line(
          points={{-12,-1.2},{-26,-1.2},{-26,34},{-35.5,34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SystemicArtys_Pressure,LowerTorsoHydrostatics. fromPressure)
        annotation (Line(
          points={{-42,58},{-30,58},{-30,-25.2},{-12,-25.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SystemicArtys_Pressure,MiddleTorsoHydrostatics. fromPressure)
        annotation (Line(
          points={{-42,58},{-30,58},{-30,12.8},{-12,12.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SystemicArtys_Pressure,UpperTorsoHydrostatics. fromPressure)
        annotation (Line(
          points={{-42,58},{-30,58},{-30,50.8},{-12,50.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(LegMusclePump_Effect,LowerTorsoHydrostatics. Pump_Effect) annotation (
         Line(
          points={{-42,-38},{-32,-38},{-32,-39.2},{-12,-39.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(UpperTorsoHydrostatics.Capy, RegionalPressure_UpperCapy) annotation (
          Line(
          points={{16,48},{46,48}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(MiddleTorsoHydrostatics.Capy, RegionalPressure_MiddleCapy)
        annotation (Line(
          points={{16,10},{46,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(LowerTorsoHydrostatics.Capy, RegionalPressure_LowerCapy) annotation (
          Line(
          points={{16,-28},{46,-28}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(UpperTorsoHydrostatics.Status_Posture, real2Posture.y) annotation (
          Line(
          points={{-12,59.2},{-32,59.2},{-32,24},{-63.2,24}},
          color={0,127,127},
          smooth=Smooth.None));

      connect(real2Posture.y, MiddleTorsoHydrostatics.Status_Posture) annotation (
          Line(
          points={{-63.2,24},{-32,24},{-32,21.2},{-12,21.2}},
          color={0,127,127},
          smooth=Smooth.None));
      connect(LowerTorsoHydrostatics.Status_Posture, real2Posture.y) annotation (
          Line(
          points={{-12,-16.8},{-32,-16.8},{-32,24},{-63.2,24}},
          color={0,127,127},
          smooth=Smooth.None));
    connect(Status_Posture, real2Posture.u) annotation (Line(
        points={{-88,24},{-72.8,24}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
              -100},{100,100}}),   graphics), Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={
            Text(
              extent={{-100,122},{100,102}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}));
    end Hydrostatics;

    connector PostureInput =
                          input Posture "'input Posture' as connector"
      annotation (defaultComponentName="u",
      Icon(graphics={Polygon(
            points={{-100,100},{100,0},{-100,-100},{-100,100}},
            lineColor={0,127,127},
            fillColor={0,127,127},
            fillPattern=FillPattern.Solid), Text(
            extent={{100,-50},{700,50}},
            lineColor={0,127,127},
            textString="%name")},
           coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
      Diagram(coordinateSystem(
            preserveAspectRatio=true, initialScale=0.2,
            extent={{-100,-100},{100,100}},
            grid={1,1}), graphics={Polygon(
            points={{0,50},{100,0},{0,-50},{0,50}},
            lineColor={0,127,127},
            fillColor={0,127,127},
            fillPattern=FillPattern.Solid), Text(
            extent={{-10,85},{-10,60}},
            lineColor={0,127,127},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Posture.
</p>
</html>"));

    connector PostureOutput =
                        output Posture "'input Posture' as connector"
    annotation (defaultComponentName="u",
    Icon(graphics={Polygon(
            points={{-100,100},{100,0},{-100,-100},{-100,100}},
            lineColor={0,127,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{100,-50},{700,50}},
            lineColor={0,127,127},
            textString="%name")},
         coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
    Diagram(coordinateSystem(
          preserveAspectRatio=true, initialScale=0.2,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={Polygon(
            points={{0,50},{100,0},{0,-50},{0,50}},
            lineColor={0,127,127},
            fillColor={0,127,127},
            fillPattern=FillPattern.Solid), Text(
            extent={{-10,85},{-10,60}},
            lineColor={0,127,127},
            textString="%name")}),
      Documentation(info="<html>
<p>
Connector with one input signal of type Posture.
</p>
</html>"));

  model Real2Posture "Convert Real to type Posture"
    extends Physiolibrary.Icons.ConversionIcon;

    PostureOutput y "Connector of Real output signal"
      annotation (Placement(transformation(extent={{60,-20},{80,0}},
          rotation=0), iconTransformation(extent={{100,-20},{140,20}})));

    Modelica.Blocks.Interfaces.RealInput u
                                    annotation (Placement(transformation(extent={{-130,
              -20},{-90,20}}),      iconTransformation(extent={{-140,-20},{-100,20}})));
    Integer tmp;
  equation

    tmp = integer(u);
    y = if tmp <= 0 then Posture.Lying elseif tmp == 1 then Posture.Sitting
     elseif tmp == 2 then Posture.Standing
     elseif tmp == 3 then Posture.Tilting else Posture.SteadyState;
    annotation (
      Icon(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}},
      grid={2,2},
      initialScale=0.04), graphics),
      Diagram(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}},
      grid={2,2},
      initialScale=0.04), graphics),
  Documentation(info="<html>
<p>
The Real output y is a constant signal:
</p>
</html>"));
  end Real2Posture;
  end Hydrostatics;

  package Osmoles "Intracellular vs. Extracellular Water"

    model OsmBody

      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                         OsmECFV_Electrolytes                                annotation (Placement(transformation(
              extent={{-120,50},{-80,90}}), iconTransformation(extent={{-100,88},{-76,
                112}})));
      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                         OsmCell_Electrolytes                                annotation (Placement(transformation(
              extent={{-120,-10},{-80,30}}),
                                           iconTransformation(extent={{-100,48},{-76,
                72}})));
      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                         UreaECF      annotation (Placement(
            transformation(extent={{-120,20},{-80,60}}), iconTransformation(extent={{-100,8},
                {-76,32}})));
      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                         UreaICF      annotation (Placement(
            transformation(extent={{-120,-40},{-80,0}}),iconTransformation(extent={{-100,
                -32},{-76,-8}})));
      Physiolibrary.Types.RealIO.VolumeInput
                                         BodyH2O_Vol "all water in body"
                                                             annotation (Placement(transformation(extent={{-120,
                -110},{-80,-70}}),   iconTransformation(extent={{-100,-112},{-76,-88}})));
      Physiolibrary.Types.RealIO.VolumeOutput
                                          ECFV "extracellular water"
                                                         annotation (Placement(transformation(extent={{60,-80},
                {100,-40}}),iconTransformation(extent={{92,28},{116,52}})));
      Physiolibrary.Types.RealIO.VolumeOutput
                                          ICFV "intracellular water"
                                                         annotation (Placement(transformation(extent={{60,60},
                {100,100}}),iconTransformation(extent={{92,68},{116,92}})));

      parameter Physiolibrary.Types.Fraction Dissociation = 0.890;

      Physiolibrary.Types.AmountOfSubstance OsmECFV_NonElectrolytes;
      Physiolibrary.Types.AmountOfSubstance OsmCell_NonElectrolytes;
      Physiolibrary.Types.AmountOfSubstance Electrolytes;
      Physiolibrary.Types.AmountOfSubstance NonElectrolytes;
      Physiolibrary.Types.AmountOfSubstance Total;
      Physiolibrary.Types.AmountOfSubstance ECFVActiveElectrolytes;
      Physiolibrary.Types.AmountOfSubstance ICFVActiveElectrolytes;
      Physiolibrary.Types.AmountOfSubstance ActiveElectrolytes;
      Physiolibrary.Types.AmountOfSubstance ECFVActiveOsmoles;
      Physiolibrary.Types.AmountOfSubstance ICFVActiveOsmoles;
      Physiolibrary.Types.AmountOfSubstance ActiveOsmoles(start=11.6831341496947);
    //  Real Osm_conc_CellWall;
      //Real Osm_conc_Osmoreceptors;
      Physiolibrary.Types.RealIO.OsmolarityOutput
                                          OsmBody_Osm_conc_CellWalls      annotation (
          Placement(transformation(extent={{60,-20},{100,20}}), iconTransformation(
              extent={{92,-12},{116,12}})));
      Physiolibrary.Types.RealIO.OsmolarityOutput
                                          Osmoreceptors( start=0.25331)
                                                                annotation (
          Placement(transformation(extent={{60,-54},{100,-14}}),iconTransformation(
              extent={{92,-52},{116,-28}})));
      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                         GlucoseECF   annotation (Placement(
            transformation(extent={{-120,-40},{-80,0}}),iconTransformation(extent={{-100,
                -72},{-76,-48}})));
      Physiolibrary.Types.RealIO.OsmolarityOutput ECFVOsmolarity annotation (
          Placement(transformation(extent={{60,-120},{100,-80}}),
            iconTransformation(extent={{92,-92},{116,-68}})));
    equation
          OsmECFV_NonElectrolytes = UreaECF + GlucoseECF + 0.340;
          OsmCell_NonElectrolytes = UreaICF + 0.354;

           Electrolytes  =  OsmECFV_Electrolytes + OsmCell_Electrolytes;
           NonElectrolytes  =  OsmECFV_NonElectrolytes + OsmCell_NonElectrolytes;
           Total  =  Electrolytes + NonElectrolytes;
           ECFVActiveElectrolytes  =  Dissociation * OsmECFV_Electrolytes;
           ICFVActiveElectrolytes  =  Dissociation * OsmCell_Electrolytes;
           ActiveElectrolytes  =  ECFVActiveElectrolytes + ICFVActiveElectrolytes;
           ECFVActiveOsmoles  =  ECFVActiveElectrolytes + OsmECFV_NonElectrolytes;
           ICFVActiveOsmoles  =  ICFVActiveElectrolytes + OsmCell_NonElectrolytes;
           ActiveOsmoles  =  ECFVActiveOsmoles + ICFVActiveOsmoles;
           OsmBody_Osm_conc_CellWalls  =  ActiveOsmoles / BodyH2O_Vol;
           Osmoreceptors  = ActiveElectrolytes / BodyH2O_Vol; //, simplified=0.25331);
           ICFV  =  ( ICFVActiveOsmoles / ActiveOsmoles)  * BodyH2O_Vol;
           ECFV  =  BodyH2O_Vol - ICFV; // == ( ECFVActiveOsmoles / ActiveOsmoles)  * BodyH2O_Vol

           ECFVOsmolarity = ECFVActiveOsmoles/ECFV; // == OsmBody_Osm_conc_CellWalls
    annotation (
    Documentation(info="<html>
<pre>QHP 2008 / OsmBody
 
</pre>
<p><br/><br/>Intracellular water calculation from cells osmotic pressure.</p>
</html>",
     revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),     Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
              -100},{100,100}}),
                    graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics),
                  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                {100,100}}),       graphics));
    end OsmBody;

    model ActiveOsmolesFake
      "Fake Distribution of active osmoles into extracellular parts to have the same extracellular osmolarity (typically 285 mosm/l)"

      Modelica.Blocks.Math.Product plasmaOsmoles
        annotation (Placement(transformation(extent={{40,9},{52,20}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-20,32},{-8,44}}),iconTransformation(extent={
              {-118,62},{-80,100}})));
      Modelica.Blocks.Math.Product upperTorsoInterstitialOsmoles
        annotation (Placement(transformation(extent={{40,-15},{52,-4}})));
      Modelica.Blocks.Math.Product middleTorsoInterstitialOsmoles
        annotation (Placement(transformation(extent={{40,-35},{52,-24}})));
      Modelica.Blocks.Math.Product lowerTorsoInterstitialOsmoles
        annotation (Placement(transformation(extent={{40,-57},{52,-46}})));
      Modelica.Blocks.Math.Product plasmaOsmoles1
        annotation (Placement(transformation(extent={{40,31},{52,42}})));
    equation
      connect(busConnector.PlasmaVol, plasmaOsmoles.u2) annotation (Line(
          points={{-14,38},{-14,11.2},{38.8,11.2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(plasmaOsmoles.y, busConnector.PlasmaActiveOsmoles) annotation (Line(
          points={{52.6,14.5},{90,14.5},{90,25},{-14,25},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(busConnector.ECFVOsmolarity, plasmaOsmoles.u1) annotation (Line(
          points={{-14,38},{-14,17.8},{38.8,17.8}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(upperTorsoInterstitialOsmoles.y, busConnector.UT.InterstitialOsmoles)
        annotation (Line(
          points={{52.6,-9.5},{92,-9.5},{92,1},{-14,1},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(busConnector.ECFVOsmolarity, upperTorsoInterstitialOsmoles.u1)
        annotation (Line(
          points={{-14,38},{-14,-6.2},{38.8,-6.2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.MT.InterstitialWater_Vol, middleTorsoInterstitialOsmoles.u2)
        annotation (Line(
          points={{-14,38},{-14,-32.8},{38.8,-32.8}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(middleTorsoInterstitialOsmoles.y, busConnector.MT.InterstitialOsmoles)
        annotation (Line(
          points={{52.6,-29.5},{92,-29.5},{92,-19},{-14,-19},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(busConnector.ECFVOsmolarity, middleTorsoInterstitialOsmoles.u1)
        annotation (Line(
          points={{-14,38},{-14,-26.2},{38.8,-26.2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.LT.InterstitialWater_Vol, lowerTorsoInterstitialOsmoles.u2) annotation (
         Line(
          points={{-14,38},{-14,-54.8},{38.8,-54.8}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(lowerTorsoInterstitialOsmoles.y, busConnector.LT.InterstitialOsmoles)
        annotation (Line(
          points={{52.6,-51.5},{92,-51.5},{92,-41},{-14,-41},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(busConnector.ECFVOsmolarity, lowerTorsoInterstitialOsmoles.u1)
        annotation (Line(
          points={{-14,38},{-14,-48.2},{38.8,-48.2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.UT.InterstitialWater_Vol, upperTorsoInterstitialOsmoles.u2)
        annotation (Line(
          points={{-14,38},{-14,-12.8},{38.8,-12.8}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
    connect(busConnector.RBCH2O_Vol, plasmaOsmoles1.u2) annotation (Line(
        points={{-14,38},{-14,33.2},{38.8,33.2}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(plasmaOsmoles1.y, busConnector.ErythrocytesOsmoles) annotation (
        Line(
        points={{52.6,36.5},{88,36.5},{88,52},{-14,52},{-14,38}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(busConnector.ECFVOsmolarity, plasmaOsmoles1.u1) annotation (Line(
        points={{-14,38},{-14,39.8},{38.8,39.8}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),   graphics));
    end ActiveOsmolesFake;

    model ActiveOsmolesFake2
      "Fake Distribution of active osmoles into extracellular parts to have the same extracellular osmolarity (typically 285 mosm/l)"

      Physiolibrary.Types.Constants.AmountOfSubstanceConst plasmaOsmoles(k=0.82)
        annotation (Placement(transformation(extent={{40,9},{52,20}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-20,32},{-8,44}}),iconTransformation(extent={
              {-118,62},{-80,100}})));
      Physiolibrary.Types.Constants.AmountOfSubstanceConst upperTorsoInterstitialOsmoles(k=0.62)
        annotation (Placement(transformation(extent={{40,-15},{52,-4}})));
      Physiolibrary.Types.Constants.AmountOfSubstanceConst middleTorsoInterstitialOsmoles(k=1.55)
        annotation (Placement(transformation(extent={{40,-35},{52,-24}})));
      Physiolibrary.Types.Constants.AmountOfSubstanceConst lowerTorsoInterstitialOsmoles(k=0.93)
        annotation (Placement(transformation(extent={{40,-57},{52,-46}})));
      Physiolibrary.Types.Constants.AmountOfSubstanceConst ErythrocytesOsmoles(k=0.43)
        annotation (Placement(transformation(extent={{40,31},{52,42}})));
    equation
      connect(plasmaOsmoles.y, busConnector.PlasmaActiveOsmoles) annotation (Line(
          points={{53.5,14.5},{90,14.5},{90,25},{-14,25},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(upperTorsoInterstitialOsmoles.y, busConnector.UT.InterstitialOsmoles)
        annotation (Line(
          points={{53.5,-9.5},{92,-9.5},{92,1},{-14,1},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(middleTorsoInterstitialOsmoles.y, busConnector.MT.InterstitialOsmoles)
        annotation (Line(
          points={{53.5,-29.5},{92,-29.5},{92,-19},{-14,-19},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(lowerTorsoInterstitialOsmoles.y, busConnector.LT.InterstitialOsmoles)
        annotation (Line(
          points={{53.5,-51.5},{92,-51.5},{92,-41},{-14,-41},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(ErythrocytesOsmoles.y, busConnector.ErythrocytesOsmoles) annotation (
          Line(
          points={{53.5,36.5},{88,36.5},{88,52},{-14,52},{-14,38}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end ActiveOsmolesFake2;
  end Osmoles;

  package WaterCompartments "Body Water Distribution"

    model Outtake

    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a     H2OLoss annotation (
        Placement(transformation(extent={{-120,-20},{-80,20}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));

    //parameter Real H2OTarget(final quantity="VolumeFlowRate",final displayUnit="ml/min") = 0;

    parameter Real H2OMassEffect[ :,3] = {{  0.0,  0.0,  0.0}, { 50.0,  1.0,  0.0}}
        "volume to outtake effect";

    Physiolibrary.Osmotic.Sources.SolventOutflux  outputPump(
        useSolutionFlowInput=true)
      annotation (Placement(transformation(extent={{20,-20},{60,20}})));
    Physiolibrary.Blocks.Interpolation.Curve curve(
      x=H2OMassEffect[:, 1],
      y=H2OMassEffect[:, 2],
      slope=H2OMassEffect[:, 3])
      annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
      Modelica.Blocks.Math.Product product
        annotation (Placement(transformation(extent={{-8,30},{12,50}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateOutput
                                            outflow "volume flow rate"
                                             annotation (Placement(
            transformation(extent={{80,-60},{120,-20}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={100,-40})));
      Physiolibrary.Types.RealIO.VolumeFlowRateInput
                                           H2OTarget(displayUnit="ml/min")
        "maximal volume outflow rate"
        annotation (Placement(transformation(extent={{-100,60},{-60,100}}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={0,40})));
      Physiolibrary.Types.RealIO.VolumeInput H2OVolume "volume" annotation (
          Placement(transformation(extent={{-118,22},{-78,62}}), iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=270,
            origin={-60,40})));
    equation

      connect(curve.val, product.u2) annotation (Line(
          points={{-40,34},{-10,34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(product.y, outflow) annotation (Line(
          points={{13,40},{84,40},{84,-40},{100,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OTarget, product.u1) annotation (Line(
          points={{-80,80},{-24,80},{-24,46},{-10,46}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(product.y, outputPump.solutionFlow) annotation (Line(
          points={{13,40},{40,40},{40,14}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OVolume, curve.u) annotation (Line(
          points={{-98,42},{-80,42},{-80,34},{-60,34}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(H2OLoss, outputPump.q_in) annotation (Line(
        points={{-100,0},{28,0}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
                {100,100}}),       graphics={Rectangle(
              extent={{-100,40},{100,-40}},
              lineColor={0,0,255},
              fillPattern=FillPattern.Solid,
              fillColor={255,255,255}), Text(
              extent={{-90,-40},{100,40}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
                      extent={{-100,-100},{100,100}}), graphics));
    end Outtake;

    model GILumenInternal
      extends Physiolibrary.SteadyStates.Interfaces.SteadyState(state_start=mass_start);
      extends Physiolibrary.Icons.GILumen;

      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                           GILumenSodium
        "sodium in gastro intestinal lumen"                                                                annotation (Placement(transformation(extent={{120,20},
                {80,60}}),
                       iconTransformation(extent={{-100,70},{-80,90}})));
      Physiolibrary.Types.RealIO.AmountOfSubstanceInput
                                           GILumenPotassium
        "potasium in gastro intestinal lumen"                   annotation (Placement(transformation(
              extent={{120,60},{80,100}}),iconTransformation(extent={{-100,10},{-80,
                30}})));

    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b absorbtion annotation (
        Placement(transformation(extent={{60,-20},{100,20}}),
          iconTransformation(extent={{90,-10},{110,10}})));

    /*Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a env annotation (
    Placement(transformation(extent={{-120,-60},{-80,-20}}),
    iconTransformation(extent={{-120,-60},{-80,-20}})));
    */
    //parameter Physiolibrary.Types.Osmolarity Fiber_mass = 0.043;
    //parameter Real Na_EqToAllConnectedOsm(final displayUnit="mOsm/mEq") = 2;
    //parameter Real K_EqToAllConnectedOsm(final displayUnit="mOsm/mEq") = 2;
    //parameter Real initialVolume(final quantity="Volume", final displayUnit="ml") = initialValue;
    parameter Physiolibrary.Types.Volume mass_start= 0.000949201;
    Physiolibrary.Types.Volume mass(start= mass_start)
        "water volume in gastro intestinal lumen";
    Physiolibrary.Types.Osmolarity OsmNa;
    Physiolibrary.Types.Osmolarity OsmK;
    //Physiolibrary.Types.Osmolarity Fiber;

      Physiolibrary.Types.RealIO.VolumeOutput
                                            Vol
                                         annotation (Placement(transformation(
              extent={{82,60},{122,100}}), iconTransformation(extent={{82,60},{122,100}})));
      Physiolibrary.Types.RealIO.OsmolarityInput Fiber
        "dietary fiber in gastro intestinal lumen" annotation (Placement(
            transformation(extent={{120,60},{80,100}}), iconTransformation(extent={{
                -100,-50},{-80,-30}})));
    initial equation
      //mass = 949.201;
    equation
    //   der(mass) = (intake.q + absorbtion.q + outtake.q)/Library.SecPerMin;

     //  env.pressure = Vol; //used in diarrea or vomitus calculation
    //   OsmNa=Na_EqToAllConnectedOsm*GILumenSodium_Mass/mass;
    //   OsmK = K_EqToAllConnectedOsm*GILumenPotassium_Mass/mass;
       OsmNa=2*GILumenSodium/mass;
       OsmK =2*GILumenPotassium/mass;

    //   Fiber =Fiber_mass; ///mass;
       absorbtion.o = (Fiber + OsmNa + OsmK);

       Vol = mass;

    state = mass;
       change = (            absorbtion.q)/60;
                 /*env.q + */
        annotation (
    Documentation(info="<HTML>
<PRE>
QHP 2008 / GILumenH2O.REF
 
Created : 13-Mar-08
Last Modified : 13-Mar-08
Author : Tom Coleman
Copyright : 2008-2008
By : University of Mississippi Medical Center
Solver : QHP 2008
Schema : 2008.0
 
Volume ========================================
 
Typical lumen volume is 1000 mL on an intake of 1.4 mL/Min.
This number is based on lumen volume being 1.4% body weight
from
 
   JCI 36:289-296, 1957.
 
Data suggests a 1L oral load is nearly all absorbed in
1 Hr.  Average rate would be 17 mL/Hr with a peak rate
of about 30.
 
   Baldes & Smirk. J.Physiol. 82:62,1934.
 
Osmolar gradient is assumed to be 0.200 mOsm/mL.
 
   Rate = Perm * Grad
   30 = Perm * 0.200
   Perm = 150
 
Temperature ===================================
 
Typical lumen heat content is 155 kCal.
 
Specific heat (SH) of H2O is 0.001 (kCal/G)/DegK.
 
To get temperature from heat
 
   DegK = 1000.0 * kCal/G (or mL)
   DegC = DegK - 273.15
   DegF = ( 9 / 5 ) * DegC + 32
 
To get heat from temperature
 
   kCal = 0.001 * DegK * mL
   kCal/Min = 0.001 * DegK * mL/Min
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                   graphics), Icon(coordinateSystem(
              preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
            graphics={
            Text(
              extent={{-100,-10},{100,-26}},
              lineColor={0,0,255},
              textString="(initial %initialVolume ml)"),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
            Text(
              extent={{-100,120},{100,104}},
              lineColor={0,0,255},
              textString="%name")}));
    end GILumenInternal;

    model GI_Absorption
      import QHP = Physiomodel;
    extends Physiolibrary.Icons.GILumen;

    Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_b vascularH2O
        "plasma osmolarity on cell membranes"
                    annotation (Placement(transformation(extent={{80,44},{100,
              64}}), iconTransformation(extent={{90,-10},{110,10}})));
    parameter Physiolibrary.Types.Osmolarity Fiber = 0.043;
    //parameter Real Na_EqToAllConnectedOsm(final displayUnit="mOsm/mEq") = 2;
    //parameter Real K_EqToAllConnectedOsm(final displayUnit="mOsm/mEq") = 2;
    //parameter Real initialVolume(final quantity="Volume", final displayUnit="ml") =  1000;

    //    Na_EqToAllConnectedOsm=Na_EqToAllConnectedOsm,
    //    K_EqToAllConnectedOsm=K_EqToAllConnectedOsm,
      Outtake vomitus
        annotation (Placement(transformation(extent={{-7,-7},{7,7}},
            rotation=180,
            origin={-34,79})));
      Outtake diarrhea
        annotation (Placement(transformation(extent={{-27,60},{-41,74}})));
    Physiolibrary.Thermodynamical.Components.Membrane absorption(cond=0.15e-6/(8.314*310.15)
            /60) annotation (Placement(transformation(
            extent={{-8,-8},{8,8}},
            rotation=0,
            origin={18,22})));
    Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePump   Diet(useSolutionFlowInput=
          true, useSoluteFlowInput=true)
      annotation (Placement(transformation(extent={{-59,-52},{-49,-42}})));
    Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure flowMeasure annotation (
        Placement(transformation(
          extent={{-7,-6},{7,6}},
          rotation=90,
          origin={42,33})));
    Physiolibrary.Blocks.Factors.Spline DietThirst(data={{233,0.0,0},{253,1.0,0.1},{
            313,15.0,0}})
      annotation (Placement(transformation(extent={{-64,-32},{-44,-12}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst Normal(k(displayUnit="ml/day")=
             2.3148148148148e-08)
        annotation (Placement(transformation(extent={{-68,-14},{-60,-6}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-98,80},{-78,100}}), iconTransformation(
            extent={{-106,-10},{-86,10}})));
    Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure   flowMeasure1 annotation (
        Placement(transformation(
          extent={{-7,7},{7,-7}},
          rotation=90,
          origin={-31,-1})));
      Physiolibrary.Thermodynamical.Components.Substance GILumen(
          useImpermeableSolutesInput=true, volume_start=0.0009492,
        useSolutionAmountInput=true)
        annotation (Placement(transformation(extent={{-34,12},{-14,32}})));
      Modelica.Blocks.Math.Add3 osmoles(
        k1=2,
        k2=2,
        k3=1) annotation (Placement(transformation(extent={{-48,22},{-36,34}})));
    equation

      connect(Normal.y, DietThirst.yBase) annotation (Line(
          points={{-59,-10},{-54,-10},{-54,-20}},
          color={0,0,127},
          smooth=Smooth.None));

    connect(flowMeasure.volumeFlowRate, busConnector.GILumenVolume_Absorption)
      annotation (Line(
        points={{45.6,33},{98,33},{98,90},{-88,90}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(busConnector.GILumenDiarrhea_H2OLoss, diarrhea.outflow)
        annotation (Line(
          points={{-88,90},{-88,64.2},{-41,64.2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.GILumenVomitus_H2OLoss, vomitus.outflow)
        annotation (Line(
          points={{-88,90},{-88,81.8},{-41,81.8}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
    connect(busConnector.GILumenVolume_Intake, flowMeasure1.volumeFlowRate)
      annotation (Line(
        points={{-88,90},{-88,-1},{-35.2,-1}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(busConnector.GILumenVomitus_H2OTarget, vomitus.H2OTarget)
        annotation (Line(
          points={{-88,90},{-88,76},{-34,76},{-34,76.2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.GILumenDiarrhea_H2OTarget, diarrhea.H2OTarget)
        annotation (Line(
          points={{-88,90},{-88,69.8},{-34,69.8}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.Osmreceptors, DietThirst.u) annotation (Line(
          points={{-88,90},{-88,-22},{-62,-22}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(diarrhea.H2OLoss, vomitus.H2OLoss) annotation (Line(
          points={{-27,67},{-24,67},{-24,79},{-27,79}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
      connect(busConnector.GILumenSodium_Mass, osmoles.u1) annotation (Line(
          points={{-88,90},{-88,32.8},{-49.2,32.8}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.GILumenPotassium_Mass, osmoles.u2) annotation (Line(
          points={{-88,90},{-88,28},{-49.2,28}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.GILumenFiber_Mass, osmoles.u3) annotation (Line(
          points={{-88,90},{-88,23.2},{-49.2,23.2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(GILumen.volume, busConnector.GILumenVolume_Mass) annotation (Line(
          points={{-18,12},{-10,12},{-10,90},{-88,90}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(GILumen.volume, vomitus.H2OVolume) annotation (Line(
          points={{-18,12},{-10,12},{-10,76.2},{-29.8,76.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(GILumen.volume, diarrhea.H2OVolume) annotation (Line(
          points={{-18,12},{-10,12},{-10,69.8},{-29.8,69.8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(diarrhea.H2OLoss, GILumen.q_in[1]) annotation (Line(
          points={{-27,67},{-24,67},{-24,22}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
      connect(osmoles.y, GILumen.impermeableSolutes[1]) annotation (Line(
          points={{-35.4,28},{-32,28}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(DietThirst.y, Diet.solutionFlow) annotation (Line(
          points={{-54,-26},{-54,-43.5}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Diet.q_out, flowMeasure1.q_in) annotation (Line(
          points={{-49,-47},{-31,-47},{-31,-8}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure.port_a, vascularH2O) annotation (Line(
          points={{42,40},{42,54},{90,54}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure.port_b, absorption.particlesOutside[1]) annotation (
          Line(
          points={{42,26},{42,22},{26,22}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(GILumen.port_a, absorption.particlesInside[1]) annotation (Line(
          points={{-24,17},{-18,17},{-18,22},{10,22}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure1.port_a, GILumen.port_a) annotation (Line(
          points={{-31,6},{-32,6},{-32,17},{-24,17}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
        annotation (
    Documentation(info="<HTML>
<PRE>
QHP 2008 / GILumenH2O.REF
 
Created : 13-Mar-08
Last Modified : 13-Mar-08
Author : Tom Coleman
Copyright : 2008-2008
By : University of Mississippi Medical Center
Solver : QHP 2008
Schema : 2008.0
 
Volume ========================================
 
Typical lumen volume is 1000 mL on an intake of 1.4 mL/Min.
This number is based on lumen volume being 1.4% body weight
from
 
   JCI 36:289-296, 1957.
 
Data suggests a 1L oral load is nearly all absorbed in
1 Hr.  Average rate would be 17 mL/Hr with a peak rate
of about 30.
 
   Baldes & Smirk. J.Physiol. 82:62,1934.
 
Osmolar gradient is assumed to be 0.200 mOsm/mL.
 
   Rate = Perm * Grad
   30 = Perm * 0.200
   Perm = 150
 
Temperature ===================================
 
Typical lumen heat content is 155 kCal.
 
Specific heat (SH) of H2O is 0.001 (kCal/G)/DegK.
 
To get temperature from heat
 
   DegK = 1000.0 * kCal/G (or mL)
   DegC = DegK - 273.15
   DegF = ( 9 / 5 ) * DegC + 32
 
To get heat from temperature
 
   kCal = 0.001 * DegK * mL
   kCal/Min = 0.001 * DegK * mL/Min
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}}),        graphics), Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={Text(
              extent={{-102,124},{98,108}},
              lineColor={0,0,255},
              textString="%name")}));
    end GI_Absorption;

    model LungEdema
    extends Physiolibrary.Icons.Lungs;

     parameter Real initialVolume(displayUnit="ml") = 0;

    Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_a q_in(o(final displayUnit=
            "g/ml")) annotation (Placement(transformation(extent={{-110,10},{
              -90,30}}), iconTransformation(extent={{-10,30},{10,50}})));
    Physiolibrary.Blocks.Interpolation.Curve ExcessLungWaterOnLymph(
      x={10,1000},
      y={0,1},
      slope={0,0},
      Xscale=1e-6,
      Yscale=1e-6/60)
      annotation (Placement(transformation(extent={{16,-26},{-4,-6}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-104,61},{-84,81}}), iconTransformation(
            extent={{60,60},{80,80}})));

    Physiolibrary.Thermodynamical.Components.Membrane pulmCapys(
        useHydraulicPressureInputs=true, cond=3.7503078792283e-10)
      annotation (Placement(transformation(extent={{-44,28},{-24,48}})));
    Physiolibrary.Thermodynamical.Components.SolutePump PulmLymph(
        useSolutionFlowInput=true, useSoluteFlowInput=true)
                                   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={-42,-2})));
    Physiolibrary.Thermodynamical.Components.Substance waterInLungs(volume_start=
          1e-09)
      annotation (Placement(transformation(extent={{16,20},{36,40}})));
    Physiolibrary.Types.Constants.PressureConst pressure(k=0)
      annotation (Placement(transformation(extent={{-12,58},{-20,66}})));
    equation
    connect(busConnector.PulmCapys_Pressure, pulmCapys.hydraulicPressureIn)
      annotation (Line(
        points={{-94,71},{-42,71},{-42,46}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(waterInLungs.volume, ExcessLungWaterOnLymph.u) annotation (Line(
        points={{32,20},{32,-16},{16,-16}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(waterInLungs.volume, busConnector.ExcessLungWater_Volume)
      annotation (Line(
        points={{32,20},{32,8},{58,8},{58,71},{-94,71}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(pressure.y, pulmCapys.hydraulicPressureOut) annotation (Line(
        points={{-21,62},{-26,62},{-26,46}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(q_in, pulmCapys.particlesInside[1]) annotation (Line(
          points={{-100,20},{-72,20},{-72,38},{-44,38}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(q_in, PulmLymph.port_a) annotation (Line(
          points={{-100,20},{-72,20},{-72,-2},{-52,-2}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(PulmLymph.port_b, waterInLungs.port_a) annotation (Line(
          points={{-32,-2},{-4,-2},{-4,25},{26,25}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(pulmCapys.particlesOutside[1], waterInLungs.port_a) annotation (
          Line(
          points={{-24,38},{-4,38},{-4,25},{26,25}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(ExcessLungWaterOnLymph.val, PulmLymph.soluteFlow) annotation (
          Line(
          points={{-4,-16},{-46,-16},{-46,-6}},
          color={0,0,127},
          smooth=Smooth.None));
        annotation (
    Documentation(info="<HTML>
<PRE>
Torso water compartment.
 
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}}),        graphics), Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={                                   Text(
              extent={{-100,88},{100,72}},
              lineColor={0,0,255},
              textString="%name")}));
    end LungEdema;

    model Peritoneum2
    extends Physiolibrary.Icons.Peritoneum;
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a flux
        "plasma proteins concentration"
                                      annotation (Placement(transformation(
            extent={{76,-8},{96,12}}), iconTransformation(extent={{-10,30},{
              10,50}})));

      parameter Physiolibrary.Types.Volume initialVolume = 0
        "initial water in peritoneum";

    Physiomodel.Metabolism.deprecated.HydraulicPressure colloidhydraulicPressure0_1
      annotation (Placement(transformation(extent={{68,34},{60,42}})));
    Physiomodel.Metabolism.deprecated.HydraulicPressure colloidhydraulicPressure0_2
      annotation (Placement(transformation(extent={{64,-6},{56,2}})));
    Physiolibrary.Types.Constants.PressureConst ExternalPressure(k=
          1199.901486735)
      annotation (Placement(transformation(extent={{-72,60},{-64,68}})));
      Physiolibrary.Hydraulic.Components.ElasticVessel
        vascularElasticBloodCompartment(volume_start=initialVolume, stateName=
            "PeritoneumSpace.Volume",
        useV0Input=true,
        useComplianceInput=true,
        useExternalPressureInput=true)
        annotation (Placement(transformation(extent={{-70,14},{-50,34}})));
    Physiolibrary.Types.Constants.VolumeConst PeritoneumSpace_V0(k=0)
        "PeritoneumSpace.V0"
      annotation (Placement(transformation(extent={{-78,36},{-70,44}})));
    Physiolibrary.Types.Constants.HydraulicComplianceConst complianceConstant(
        k=5.700467976427015e-006)
      annotation (Placement(transformation(extent={{-74,48},{-66,56}})));

    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-84,71},{-64,91}}), iconTransformation(
            extent={{60,60},{80,80}})));

      Physiolibrary.Hydraulic.Components.IdealValve idealValve
        annotation (Placement(transformation(extent={{30,-8},{50,12}})));
      Physiolibrary.Hydraulic.Components.Conductor lymph(Conductance=1.8751539396141e-10)
        annotation (Placement(transformation(extent={{-32,-8},{-12,12}})));
      Physiolibrary.Hydraulic.Sensors.FlowMeasure flowMeasure
        annotation (Placement(transformation(extent={{2,-8},{22,12}})));
      Physiolibrary.Hydraulic.Components.Conductor splanchnic(Conductance=1.8751539396141e-10)
        annotation (Placement(transformation(extent={{-28,32},{-8,52}})));
      Physiolibrary.Hydraulic.Sensors.FlowMeasure flowMeasure1
        annotation (Placement(transformation(extent={{20,52},{0,32}})));

    Physiolibrary.Osmotic.Sensors.FlowMeasure flowMeasure2
      annotation (Placement(transformation(extent={{82,32},{70,16}})));
    equation
      connect(colloidhydraulicPressure0_2.hydraulicPressure, ExternalPressure.y)
        annotation (Line(
          points={{58.4,2.8},{58.4,20},{-38,20},{-38,64},{-63,64}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.SplanchnicVeins_Pressure,
        colloidhydraulicPressure0_1.hydraulicPressure) annotation (Line(
          points={{-74,81},{62.4,81},{62.4,42.8}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(colloidhydraulicPressure0_2.withoutCOP, idealValve.q_out) annotation (
         Line(
          points={{56,2},{50,2}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(lymph.q_out, flowMeasure.q_in) annotation (Line(
          points={{-12,2},{2,2}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(idealValve.q_in, flowMeasure.q_out) annotation (Line(
          points={{30,2},{22,2}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure.volumeFlow, busConnector.PeritoneumSpace_Loss)
        annotation (Line(
          points={{12,14},{12,-16},{94,-16},{94,81},{-74,81}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flowMeasure1.q_in, colloidhydraulicPressure0_1.withoutCOP)
        annotation (Line(
          points={{20,42},{60,42}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure1.q_out, splanchnic.q_out) annotation (Line(
          points={{0,42},{-8,42}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure1.volumeFlow, busConnector.PeritoneumSpace_Gain)
        annotation (Line(
          points={{10,30},{10,81},{-74,81}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(PeritoneumSpace_V0.y, vascularElasticBloodCompartment.zeroPressureVolume)
        annotation (Line(
          points={{-69,40},{-68,40},{-68,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ExternalPressure.y, vascularElasticBloodCompartment.externalPressure)
        annotation (Line(
          points={{-63,64},{-52,64},{-52,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(complianceConstant.y, vascularElasticBloodCompartment.compliance)
        annotation (Line(
          points={{-65,52},{-60,52},{-60,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.PeritoneumSpace_Vol,
        vascularElasticBloodCompartment.volume) annotation (Line(
          points={{-74,81},{-96,81},{-96,14},{-54,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(vascularElasticBloodCompartment.q_in, splanchnic.q_in)
        annotation (Line(
          points={{-60,24},{-36,24},{-36,42},{-28,42}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(vascularElasticBloodCompartment.q_in, lymph.q_in)
        annotation (Line(
          points={{-60,24},{-46,24},{-46,2},{-32,2}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
    connect(flux, flowMeasure2.q_in) annotation (Line(
        points={{86,2},{86,24},{82,24}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(colloidhydraulicPressure0_1.q_in, flowMeasure2.q_out) annotation (
       Line(
        points={{68,38},{70,38},{70,24}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(colloidhydraulicPressure0_2.q_in, flowMeasure2.q_out) annotation (
       Line(
        points={{64,-2},{70,-2},{70,24}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(flowMeasure2.volumeFlowRate, busConnector.PeritoneumSpace_Change)
      annotation (Line(
        points={{76,30.4},{76,81},{-74,81}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (
    Documentation(info="<HTML>
<PRE>
QHP 2008 / Peritoneum
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Text(
              extent={{-100,120},{100,104}},
              lineColor={0,0,255},
              textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),   graphics));
    end Peritoneum2;

    model Torso
      import Physiomodel;
        extends Physiolibrary.Icons.Torso;

    //    parameter Real interstitiumProteins = 2.6;

        parameter Physiolibrary.Types.Volume InterstitialWater_start
        "2270,5670,3400 ml";
        parameter Physiolibrary.Types.Volume IntracellularWater_start
        "4980,12460,7470 ml";

        parameter Physiolibrary.Types.VolumeFlowRate NormalLymphFlow
        "0.4,0.8,1.3 ml/min";

        parameter Physiolibrary.Types.OsmoticPermeability CapillaryWaterPermeability
        "Capillary wall permeability for water. 0.6, 3.6, 1.3 ml/(kPa.min)";

        parameter Real[ :,3] InterstitialPressureVolumeData
        "{{600.0,-30.0,0.01},{2000.0,-4.8,0.0004},{5000.0,0.0,0.0004},{12000.0,50.0,0.01}}, {{1200.0,-30.0,0.01},{4800.0,-4.8,0.0004},{12000.0,0.0,0.0004},{24000.0,50.0,0.01}}, {{600.0,-30.0,0.02},{3000.0,-4.8,0.0004},{4000.0,-4.0,0.0004},{6000.0,50.0,0.03}}";
        parameter Physiolibrary.Types.Fraction ICFVFract
        "0.94. Ratio between non-RBC-ICFV and total ICFV, because red cells are not part of any torso ICF!";
        parameter Physiolibrary.Types.Fraction SizeFract "0.2,0.5,0.3";
        parameter Physiolibrary.Types.Fraction CalsFract "0.3,0.5,0.2";
        parameter Physiolibrary.Types.Fraction SweatFract "0.33,0.34,0.33";
        parameter Physiolibrary.Types.Fraction SkinFract "0.33,0.34,0.33";
        parameter Physiolibrary.Types.Fraction LungFract "0,1,0";

    Physiolibrary.Types.TorsoBusConnector torsoSpecific annotation (Placement(
          transformation(extent={{62,27},{80,44}}), iconTransformation(extent=
             {{30,10},{50,30}})));
    Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_a vascularH2O
        "plasma capillary wall osmotic connector"
      annotation (Placement(transformation(extent={{-92,-42},{-72,-22}}),
          iconTransformation(extent={{-70,-10},{-50,10}})));
      Modelica.Blocks.Math.Gain calsFract(k=CalsFract) annotation (Placement(
            transformation(
            extent={{-6,-6},{6,6}},
            rotation=0,
            origin={48,-82})));

    //  Physiolibrary.Types.Volume volume;
    //  Physiolibrary.Types.VolumeFlowRate change;
    Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePump metabolicH2O(
          useSoluteFlowInput=true)
        annotation (Placement(transformation(extent={{68,-98},{88,-78}})));
    Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure flowMeasure1 annotation (
        Placement(transformation(
          extent={{5,4},{-5,-4}},
          rotation=270,
          origin={24,47})));
    Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure flowMeasure2 annotation (
        Placement(transformation(
          extent={{5,6},{-5,-6}},
          rotation=270,
          origin={8,27})));
      Physiolibrary.Thermodynamical.Components.Membrane capyMembrane(
        useHydraulicPressureInputs=true,
        Permeabilities={CapillaryWaterPermeability})
        annotation (Placement(transformation(extent={{-60,-24},{-40,-4}})));
        Physiolibrary.Thermodynamical.Components.SolutePump          lymph(
          useSoluteFlowInput=true)
                annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=180,
          origin={-54,-72})));
    Physiolibrary.Blocks.Factors.Spline InterstitialPressureEffect(
        data={{-14.0,0.0,0.0},{-4.0,1.0,0.1},{2.0,8.0,4.0},{6.0,25.0,0.0}},
        Xscale=101325/760,
        y(unit="m3/s"))
      annotation (Placement(transformation(extent={{-48,-68},{-68,-48}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst flowConstant(k=
            NormalLymphFlow)
      annotation (Placement(transformation(extent={{-68,-50},{-60,-42}})));
      Physiolibrary.Thermodynamical.Components.Substance Interstitium(
        amountOfSubstance_start=InterstitialWater_start,
        useSolutionAmountInput=true)
        "Iterstitium has two type of membranes: capillary membrane (index 1) and cell membrane (index 2)"
        annotation (Placement(transformation(extent={{18,-10},{-2,10}})));
      Physiolibrary.Blocks.Interpolation.Curve pressureOnVolume(
        Xscale=1e-6,
        Yscale=101325/760,
      data=InterstitialPressureVolumeData)
        annotation (Placement(transformation(extent={{4,-50},{-16,-30}})));
    Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePumpOut sweat(useSoluteFlowInput=
          true)
      annotation (Placement(transformation(extent={{10,10},{-10,-10}},
          rotation=270,
          origin={24,66})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst Vapor(k=
          6.1666666666667e-09)
        annotation (Placement(transformation(extent={{-24,42},{-16,50}})));
    Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePumpOut insensibleSkinVapor(
          useSoluteFlowInput=true) annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=270,
            origin={8,46})));
      Physiolibrary.Thermodynamical.Components.Substance ICF(
          amountOfSubstance_start=IntracellularWater_start,
        useSolutionAmountInput=true)
        annotation (Placement(transformation(extent={{94,-66},{74,-46}})));
      Physiolibrary.Thermodynamical.Components.Membrane cellMembrane(
         useHydraulicPressureInputs=false,
       Permeabilities={CapillaryWaterPermeability})
        annotation (Placement(transformation(extent={{52,-44},{72,-24}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{30,70},{50,90}}), iconTransformation(extent=
             {{30,70},{50,90}})));
      Modelica.Blocks.Math.Gain sizeFract(k=SizeFract*ICFVFract)
                                                       annotation (Placement(
            transformation(
            extent={{6,-6},{-6,6}},
            rotation=180,
            origin={90,72})));
    Modelica.Blocks.Math.Gain lungFract(k=LungFract)
      annotation (Placement(transformation(extent={{-24,24},{-16,32}})));
    Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePumpOut insensibleLungVapor(
        useSoluteFlowInput=true) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-6,28})));
    Modelica.Blocks.Math.Gain skinFract(k=SkinFract) annotation (Placement(
          transformation(
          extent={{-4,-4},{4,4}},
          rotation=0,
          origin={-6,46})));
    Modelica.Blocks.Math.Gain sweatFract(k=SweatFract) annotation (Placement(
          transformation(
          extent={{-4,-4},{4,4}},
          rotation=0,
          origin={10,66})));

      Physiolibrary.Types.VolumeFlowRate fromCapillaries, toLymph, evaporation, fromMetabolism;
    equation
      fromCapillaries = capyMembrane.q_in.q;
      toLymph = lymph.q_out.q;
      evaporation = insensibleLungVapor.q_in.q + insensibleSkinVapor.q_in.q + sweat.q_in.q;
      fromMetabolism = metabolicH2O.q_out.q;

    //  volume = extravascularH2O.WaterVolume;
    //  change = extravascularH2O.q_out.q;

      connect(flowConstant.y,InterstitialPressureEffect. yBase) annotation (
          Line(
          points={{-59,-46},{-58,-46},{-58,-56}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pressureOnVolume.u, Interstitium.volume) annotation (Line(
          points={{4,-40},{2,-40},{2,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pressureOnVolume.val, capyMembrane.hydraulicPressureOut) annotation (
          Line(
          points={{-16,-40},{-20,-40},{-20,-6},{-42,-6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pressureOnVolume.val, InterstitialPressureEffect.u) annotation (Line(
          points={{-16,-40},{-20,-40},{-20,-58},{-50,-58}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(flowMeasure1.volumeFlowRate, torsoSpecific.Sweat_H2OOutflow)
      annotation (Line(
        points={{26.4,45},{54,45},{54,35.5},{71,35.5}},
        color={215,215,215},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(flowMeasure2.volumeFlowRate, torsoSpecific.InsensibleSkin_H2O)
      annotation (Line(
        points={{11.6,27},{54,27},{54,35.5},{71,35.5}},
        color={215,215,215},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(Interstitium.volume, torsoSpecific.InterstitialWater_Vol) annotation (
         Line(
          points={{2,-10},{54,-10},{54,35.5},{71,35.5}},
          color={215,215,215},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(Interstitium.impermeableSolutes[1], torsoSpecific.InterstitialProtein_Mass)
        annotation (Line(
          points={{16,5},{54,5},{54,35.5},{71,35.5}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(InterstitialPressureEffect.y, torsoSpecific.LymphFlow) annotation (
         Line(
          points={{-58,-62},{52,-62},{52,35.5},{71,35.5}},
          color={215,215,215},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(ICF.impermeableSolutes[1], sizeFract.y) annotation (Line(
          points={{92,-50},{96,-50},{96,72},{96.6,72}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.OsmBody_ICFVActiveOsmoles, sizeFract.u) annotation (Line(
          points={{40,80},{40,72},{82.8,72}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(torsoSpecific.CapillaryRegionalPressure, capyMembrane.hydraulicPressureIn)
        annotation (Line(
          points={{71,35.5},{71,36},{56,36},{56,14},{-98,14},{-98,-6},{-58,-6}},
          color={170,255,255},
          smooth=Smooth.None,
        thickness=0.5),        Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
    connect(Vapor.y, skinFract.u) annotation (Line(
        points={{-15,46},{-10.8,46}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.SweatDuct_H2OOutflow, sweatFract.u) annotation (Line(
        points={{40,80},{-66,80},{-66,66},{5.2,66}},
        color={0,0,255},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.HeatInsensibleLung_H2O, lungFract.u) annotation (
        Line(
        points={{40,80},{-66,80},{-66,28},{-24.8,28}},
        color={0,0,255},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(torsoSpecific.Cell_H2O, ICF.volume) annotation (Line(
        points={{71,35.5},{54,35.5},{54,-66},{78,-66}},
        color={215,215,215},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.MetabolicH2O_Rate, calsFract.u) annotation (Line(
        points={{40,80},{-100,80},{-100,-82},{40.8,-82}},
        color={0,0,255},
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(Interstitium.impermeableSolutes[2], torsoSpecific.InterstitialOsmoles)
        annotation (Line(
          points={{16,7},{68,7},{68,35.5},{71,35.5}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(calsFract.y, metabolicH2O.soluteFlow) annotation (Line(
          points={{54.6,-82},{68,-82},{68,-78},{82,-78},{82,-84}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(skinFract.y, insensibleSkinVapor.soluteFlow) annotation (Line(
          points={{-1.6,46},{2,46},{2,50},{4,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(lungFract.y, insensibleLungVapor.soluteFlow) annotation (Line(
          points={{-15.6,28},{-14,28},{-14,32},{-10,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sweatFract.y, sweat.soluteFlow) annotation (Line(
          points={{14.4,66},{16,66},{16,70},{20,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flowMeasure1.port_a, sweat.q_in) annotation (Line(
          points={{24,52},{24,56}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure2.port_a, insensibleSkinVapor.q_in) annotation (Line(
          points={{8,32},{8,36}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(Interstitium.port_a, cellMembrane.particlesInside[1]) annotation (
          Line(
          points={{8,-5},{36,-5},{36,-34},{52,-34}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(Interstitium.port_a, flowMeasure2.port_b) annotation (Line(
          points={{8,-5},{8,22}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(Interstitium.port_a, flowMeasure1.port_b) annotation (Line(
          points={{8,-5},{8,16},{24,16},{24,42}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(Interstitium.port_a, capyMembrane.particlesOutside[1]) annotation (
          Line(
          points={{8,-5},{-26,-5},{-26,-14},{-40,-14}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(cellMembrane.particlesOutside[1], ICF.port_a) annotation (Line(
          points={{72,-34},{84,-34},{84,-61}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(ICF.port_a, metabolicH2O.q_out) annotation (Line(
          points={{84,-61},{96,-61},{96,-88},{88,-88}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(lymph.port_a, vascularH2O) annotation (Line(
          points={{-64,-72},{-76,-72},{-76,-32},{-82,-32}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(capyMembrane.particlesInside[1], vascularH2O) annotation (Line(
          points={{-60,-14},{-76,-14},{-76,-32},{-82,-32}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(lymph.port_b, Interstitium.port_a) annotation (Line(
          points={{-44,-72},{-26,-72},{-26,-5},{8,-5}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(InterstitialPressureEffect.y, lymph.soluteFlow) annotation (Line(
          points={{-58,-62},{-58,-68}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Interstitium.port_a, insensibleLungVapor.q_in) annotation (Line(
          points={{8,-5},{8,16},{-6,16},{-6,18}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={                 Text(
              extent={{-139,-101},{142,-126}},
              lineColor={0,0,255},
              textString="%name")}));
    end Torso;

    model CerebrospinalFluid
        extends Physiolibrary.Icons.Brain;
    Physiolibrary.Osmotic.Components.OsmoticCell CSF_osmotic(volume_start(
          displayUnit="ml") = 0.00015, ImpermeableSolutes={(0.286*0.15)})
        "cerebro-spinal fluid"
      annotation (Placement(transformation(extent={{-78,-16},{-58,4}})));
      Physiolibrary.Osmotic.Components.Membrane
                          choroid_plexus(useHydraulicPressureInputs=true, cond(
            displayUnit="ml/(mmHg.day)") = 1.9966916949595e-12)
        "choroid plexus"
        annotation (Placement(transformation(extent={{-18,-16},{-38,4}})));
      Physiolibrary.Hydraulic.Components.ElasticVessel
                                         CSF_hydraulic(
        volume_start=0.00015,
        ZeroPressureVolume=0.000145,
        Compliance=2.250184727537e-09) "cerebro-spinal fluid"
        annotation (Placement(transformation(extent={{-98,-42},{-78,-22}})));
      Physiolibrary.Hydraulic.Components.Pump
                                choroid_plexus_hydraulic(useSolutionFlowInput=
            true) annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={6,-32})));
      Physiolibrary.Osmotic.Sensors.FlowMeasure
                          flowMeasure annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={6,-6})));
      Physiolibrary.Hydraulic.Sensors.PressureMeasure
                                        pressureMeasure
        annotation (Placement(transformation(extent={{-92,54},{-72,74}})));
      Physiolibrary.Hydraulic.Sources.UnlimitedVolume
                                        veins(P=0) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={80,76})));
      Physiolibrary.Osmotic.Components.Membrane
                          arachnoid_villi(useHydraulicPressureInputs=true, cond(
            displayUnit="ml/(mmHg.day)") = 1.1285648710641e-11)
        "choroid plexus"
        annotation (Placement(transformation(extent={{-38,36},{-18,56}})));
      Physiolibrary.Hydraulic.Components.Pump
                                arachnoid_villi_hydraulic(useSolutionFlowInput=
            true)
        annotation (Placement(transformation(extent={{-4,86},{16,66}})));
      Physiolibrary.Osmotic.Sensors.FlowMeasure
                          flowMeasure1
        annotation (Placement(transformation(extent={{-4,56},{16,36}})));
      Physiolibrary.Hydraulic.Sources.UnlimitedVolume choroidPlexusCapy(P=
          3733.02684762) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={80,-28})));
      Physiolibrary.Hydraulic.Sensors.PressureMeasure
                                        pressureMeasure1
        annotation (Placement(transformation(extent={{66,54},{46,74}})));
      Physiolibrary.Hydraulic.Sensors.PressureMeasure
                                        pressureMeasure2
        annotation (Placement(transformation(extent={{60,-32},{40,-12}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a flux
        "plasma proteins concentration"
                                      annotation (Placement(transformation(
            extent={{46,14},{66,34}}), iconTransformation(extent={{-10,30},{
              10,50}})));
    Physiolibrary.Osmotic.Components.PermeabilityLevelSwitch
      permeabilityLevelSwitch
      annotation (Placement(transformation(extent={{44,14},{24,34}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{28,81},{48,101}}), iconTransformation(
            extent={{50,-10},{70,10}})));
    equation

    connect(flowMeasure.volumeFlowRate, choroid_plexus_hydraulic.solutionFlow)
      annotation (Line(
        points={{6,-12},{6,-25}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(CSF_hydraulic.q_in,pressureMeasure. q_in) annotation (Line(
          points={{-88,-32},{-88,58},{-86,58}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(CSF_hydraulic.q_in,choroid_plexus_hydraulic. q_out) annotation (
          Line(
          points={{-88,-32},{-4,-32}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
    connect(CSF_osmotic.q_in[1], arachnoid_villi.q_in) annotation (Line(
        points={{-68,-6},{-68,46},{-38,46}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
      connect(CSF_hydraulic.q_in,arachnoid_villi_hydraulic. q_in) annotation (
          Line(
          points={{-88,-32},{-88,76},{-4,76}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(arachnoid_villi_hydraulic.q_out,veins. y) annotation (Line(
          points={{16,76},{70,76}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
    connect(pressureMeasure.pressure, arachnoid_villi.hydraulicPressureIn)
      annotation (Line(
        points={{-76,60},{-36,60},{-36,54}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(arachnoid_villi.q_out,flowMeasure1. q_in) annotation (Line(
          points={{-18,46},{-4,46}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
    connect(flowMeasure1.volumeFlowRate, arachnoid_villi_hydraulic.solutionFlow)
      annotation (Line(
        points={{6,52},{6,69}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(pressureMeasure1.q_in,veins. y) annotation (Line(
          points={{60,58},{64,58},{64,76},{70,76}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
    connect(pressureMeasure1.pressure, arachnoid_villi.hydraulicPressureOut)
      annotation (Line(
        points={{50,60},{-20,60},{-20,54}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(CSF_osmotic.q_in[1], choroid_plexus.q_out) annotation (Line(
        points={{-68,-6},{-38,-6}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
      connect(choroid_plexus.q_in,flowMeasure. q_out) annotation (Line(
          points={{-18,-6},{-4,-6}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
    connect(pressureMeasure.pressure, choroid_plexus.hydraulicPressureOut)
      annotation (Line(
        points={{-76,60},{-44,60},{-44,10},{-36,10},{-36,2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pressureMeasure2.pressure, choroid_plexus.hydraulicPressureIn)
      annotation (Line(
        points={{44,-26},{26,-26},{26,10},{-20,10},{-20,2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(flux, permeabilityLevelSwitch.q_in) annotation (Line(
        points={{56,24},{44,24}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(flowMeasure.q_in, permeabilityLevelSwitch.q_out) annotation (Line(
        points={{16,-6},{20,-6},{20,24},{24,24}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(permeabilityLevelSwitch.q_out, flowMeasure1.q_out) annotation (
        Line(
        points={{24,24},{20,24},{20,46},{16,46}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
    connect(permeabilityLevelSwitch.additionalOsmolarity, busConnector.OsmBody_Osm_conc_CellWalls)
      annotation (Line(
        points={{24,34},{24,63},{38,63},{38,91}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(choroidPlexusCapy.y, choroid_plexus_hydraulic.q_in) annotation (
        Line(
        points={{70,-28},{54,-28},{54,-32},{16,-32}},
        color={0,0,0},
        thickness=1,
        smooth=Smooth.None));
    connect(choroidPlexusCapy.y, pressureMeasure2.q_in) annotation (Line(
        points={{70,-28},{54,-28}},
        color={0,0,0},
        thickness=1,
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}}), graphics),  Icon(graphics={
                                       Text(
              extent={{-145,87},{136,62}},
              lineColor={0,0,255},
              textString="%name")}));
    end CerebrospinalFluid;

    model Bladder
     // extends Library.PressureFlow.VolumeCompartement;
      extends Physiolibrary.Icons.Bladder;
      Physiolibrary.Hydraulic.Components.ElasticVessel   volumeCompartement(
        stateName="BladderVolume.Mass", volume_start=0.0002)
        annotation (Placement(transformation(extent={{-18,0},{2,20}})));
    Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a con annotation (
        Placement(transformation(extent={{-84,18},{-44,58}}, rotation=0),
          iconTransformation(extent={{-120,-20},{-80,20}})));
    Physiolibrary.Hydraulic.Sources.UnlimitedOutflowPump
                                                  bladderVoidFlow(
        useSolutionFlowInput=true)
      annotation (Placement(transformation(extent={{-58,-23},{-73,-8}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-100,69},{-80,89}}), iconTransformation(
            extent={{-100,-100},{-80,-80}})));

    //  Real volume;
    //  Real change;
    equation
    //  volume = volumeCompartement.Volume;
    //  change = volumeCompartement.con.q;

    connect(busConnector.BladderVoidFlow, bladderVoidFlow.solutionFlow)
      annotation (Line(
        points={{-90,79},{-90,0},{-65.5,0},{-65.5,-10.25}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
      connect(con, volumeCompartement.q_in) annotation (Line(
          points={{-64,38},{-36,38},{-36,10},{-8,10}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(bladderVoidFlow.q_in, volumeCompartement.q_in) annotation (Line(
          points={{-58,-15.5},{-36,-15.5},{-36,10},{-8,10}},
          color={0,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(volumeCompartement.volume, busConnector.BladderVolume_Mass)
        annotation (Line(
          points={{-2,0},{46,0},{46,80},{-90,80},{-90,79}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={Text(
              extent={{-100,96},{100,80}},
              lineColor={0,0,255},
              textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
              extent={{-100,-100},{100,100}}), graphics));
    end Bladder;

    package Kidney "Kidney Water Excretion"
       extends Physiolibrary.Icons.Kidney;

      model DistalTubule

      Physiolibrary.Osmotic.Interfaces.OsmoticPort_a Inflow annotation (
          Placement(transformation(extent={{-120,-20},{-80,20}}),
            iconTransformation(extent={{-120,-20},{-80,20}})));
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_b Outflow
        annotation (Placement(transformation(extent={{80,-20},{120,20}})));
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_b Reabsorbtion
        annotation (Placement(transformation(extent={{-20,-60},{20,-20}}),
            iconTransformation(extent={{-20,-60},{20,-20}})));
        Physiolibrary.Types.RealIO.VolumeFlowRateInput DesiredFlow(displayUnit="ml/min")
                                     annotation (Placement(transformation(extent={{-20,20},{20,
                  60}}), iconTransformation(extent={{-20,-20},{20,20}},
                                                                      rotation=-90,
              origin={60,40})));
      equation
        Outflow.q + Inflow.q + Reabsorbtion.q = 0;
        Inflow.o = Outflow.o;
        Outflow.q = - DesiredFlow;
        annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
                -100},{100,100}}),   graphics={
              Rectangle(
                extent={{-100,40},{100,-40}},
                lineColor={127,127,0},
                fillColor={255,255,170},
                fillPattern=FillPattern.HorizontalCylinder),
              Line(
                points={{-70,14},{-70,-18},{-52,-12},{-36,-14},{-18,-20},{-2,
                    -28},{6,-36},{8,-40},{6,-22},{0,-12},{-8,-6},{-22,2},{-40,
                    8},{-58,12},{-70,14}},
                color={0,0,255},
                smooth=Smooth.None),
              Text(
                extent={{12,-42},{166,-72}},
                lineColor={0,0,255},
                textString="%name"),
              Polygon(
                points={{20,14},{20,-14},{82,-2},{20,14}},
                lineColor={0,0,255},
                smooth=Smooth.None,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid)}),
                                       Diagram(coordinateSystem(preserveAspectRatio=true,
                        extent={{-100,-100},{100,100}}), graphics));
      end DistalTubule;

      model CD_H2OChannels
        extends Physiolibrary.SteadyStates.Interfaces.SteadyState(
                                                      stateName="CD_H2OChannels.Inactive", state_start = 2-initialActive);

      parameter Physiolibrary.Types.Fraction initialActive(final displayUnit="1") = 1;
      parameter Physiolibrary.Types.Volume InactivateKinv(final displayUnit="ml")
          "1/0.000125 ml";
      parameter Physiolibrary.Types.Frequency ReactivateK(final displayUnit="1/min")
          "0.0004 1/min";

      Physiolibrary.Osmotic.Interfaces.OsmoticPort_a     CD_H2O_Reab
        annotation (Placement(transformation(extent={{-20,80},{20,120}}),
            iconTransformation(extent={{-20,80},{20,120}})));

        Physiolibrary.Types.Fraction Inactive( start = 2-initialActive, final displayUnit="1");
        Physiolibrary.Types.RealIO.FractionOutput Active(final displayUnit="1")
                                   annotation (Placement(transformation(extent={{96,46},
                  {136,86}}), iconTransformation(extent={{96,46},{136,86}})));
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_b     q_out annotation (
          Placement(transformation(extent={{-20,-120},{20,-80}}),
            iconTransformation(extent={{-20,-120},{20,-80}})));
      equation
        q_out.q + CD_H2O_Reab.q = 0;
        q_out.o = CD_H2O_Reab.o;

      //  der(Inactive) = ((1/InactivateKinv) * CD_H2O_Reab.q - ReactivateK * Inactive) / Library.SecPerMin;
        Active = 2 - Inactive;

      state = Inactive;
        change = ((1/InactivateKinv) * CD_H2O_Reab.q - ReactivateK * Inactive);
        annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
                  {100,100}}),       graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,255},
                fillColor={170,255,255},
                fillPattern=FillPattern.Solid),Text(
                extent={{-100,-22},{100,-38}},
                lineColor={0,0,255},
                textString="(initial %initialActive)")}), Diagram(coordinateSystem(
                preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
      end CD_H2OChannels;

      model Kidney
         extends Physiolibrary.Icons.Kidney;
        import QHP = Physiomodel;
      Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_b     urine
          "H2O excretion"
                        annotation (Placement(transformation(extent={{78,-82},
                {100,-62}}),iconTransformation(extent={{-10,-110},{10,-90}})));
      Physiolibrary.Thermodynamical.Components.Reabsorption   LoopOfHenle
        annotation (Placement(transformation(extent={{-12,-68},{6,-50}})));
        Modelica.Blocks.Math.Gain gain(k=0.37)
          annotation (Placement(transformation(extent={{4,-4},{-4,4}},      rotation=180,
              origin={-24,-64})));
      Physiolibrary.Blocks.Factors.Normalization ADHEffect(yBase(nominal=1e-5),
          y(nominal=1e-7))
        annotation (Placement(transformation(extent={{34,52},{14,72}})));
      Physiolibrary.Thermodynamical.Components.Reabsorption   CollectingDuct(
          useExternalOutflowMin=true,
          useMaxReabInput=true,
          useBaseReabsorption=true,
          useEffect=false)
        annotation (Placement(transformation(extent={{34,-26},{54,-6}})));
        Modelica.Blocks.Math.Gain gain1(k=0.5)
          annotation (Placement(transformation(extent={{54,24},{50,28}})));
        Modelica.Blocks.Math.Sum sum1(nin=4)
          annotation (Placement(transformation(extent={{3,-3},{-5,5}},
              rotation=90,
              origin={49,17})));
      Physiolibrary.Blocks.Factors.Normalization MedullaNaEffect
        annotation (Placement(transformation(extent={{58,-4},{38,16}})));
      Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_a plasma
          "blood plasma"
          annotation (Placement(transformation(extent={{-108,20},{-88,40}}),
              iconTransformation(extent={{30,-10},{50,10}})));
        QHP.Water.WaterCompartments.Kidney.CD_H2OChannels H2OChannels(
          initialActive=0.969492,
          InactivateKinv=0.008,
          ReactivateK=6.6666666666667e-06)
          annotation (Placement(transformation(extent={{34,-68},{54,-48}})));
      Physiolibrary.Blocks.Math.Reciprocal inv1 annotation (Placement(
            transformation(
            extent={{2,-2},{-2,2}},
            rotation=0,
            origin={38,60})));
      Physiolibrary.Blocks.Math.Reciprocal inv2 annotation (Placement(
            transformation(
            extent={{-5,-5},{3,3}},
            rotation=180,
            origin={65,5})));
      Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure   flowMeasure1
        annotation (Placement(transformation(extent={{62,-2},{82,-22}})));
      Physiolibrary.Blocks.Factors.LagSpline
                                          NephronADHOnPerm(data={{0.0,0.3,0},
            {2.0,1.0,0.5},{10.0,3.0,0}}, Xscale=1e-9/QHP.Substances.Vasopressin.mw,
        HalfTime=Modelica.Math.log(2)*20*60,
        initialValue=2.0)
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=270,
            origin={72,-44})));
      Physiolibrary.Blocks.Factors.Spline PermOnOutflow(data={{0.3,0.00,0},{
            1.0,0.93,0.1},{3.0,1.00,0}}) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=270,
            origin={66,-30})));
      Physiolibrary.Types.Constants.FractionConst             Constant(k=1)
        annotation (Placement(transformation(extent={{76,-32},{72,-28}})));
      Physiolibrary.Types.Constants.FractionConst             Constant1(k=1)
        annotation (Placement(transformation(extent={{38,72},{44,78}})));
      Physiolibrary.Blocks.Factors.LagSpline
                                          NephronADHEffect(data={{0.0,0.060,0},
            {2.0,0.110,0.02},{10,0.160,0}}, Xscale=1e-9/QHP.Substances.Vasopressin.mw,
        HalfTime=Modelica.Math.log(2)*20*60,
        initialValue=2.0,
        Yscale=1e3) "initial: 2 pg/ml = 2e-9 kg/m3, NephronADH.Tau = 20 min"
        annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=0,
            origin={46,68})));
      Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure   flowMeasure2 annotation (
          Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={26,-80})));
      Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure   flowMeasure3 annotation (
          Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=90,
            origin={12,-30})));
      Physiolibrary.Types.BusConnector busConnector annotation (Placement(
            transformation(extent={{-102,76},{-82,96}}), iconTransformation(
              extent={{-70,66},{-50,86}})));
        Physiolibrary.Thermodynamical.Components.Membrane glomerulus(
            useHydraulicPressureInputs=true,
        useConductanceInput=true)
          annotation (Placement(transformation(extent={{-66,48},{-46,68}})));
        Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure flowMeasure4 annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-44,24})));
        Physiolibrary.Types.Constants.PressureConst PelvisPressure(k=0)
        annotation (Placement(transformation(extent={{-34,70},{-42,78}})));
        Physiolibrary.Thermodynamical.Components.Reabsorption ProximalTubule
          annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=90,
            origin={-18,44})));
      Physiolibrary.Types.Constants.VolumeConst MedullaVolume(k=3.1e-05)
        annotation (Placement(transformation(extent={{-86,-94},{-78,-86}})));
      Physiolibrary.Types.Constants.OsmoticPermeabilityConst Perm(k(displayUnit="ml/(mmHg.min)")=
               6.500533657329e-10)
          "glomerular Kf and PT conductance (permeability"
        annotation (Placement(transformation(extent={{-68,90},{-60,98}})));
      Physiolibrary.Blocks.Factors.Normalization NephronCountEffect
        annotation (Placement(transformation(extent={{-66,68},{-46,88}})));
        Physiolibrary.Thermodynamical.Components.IdealOverflowFiltration
                                                             glomerulusFlow(
            useSolutionFlowInput=true) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-78,44})));
      Physiolibrary.Thermodynamical.Components.SolutePump distalTubule(
          useSolutionFlowInput=true, useSoluteFlowInput=true)
                                     annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={24,46})));
      equation

        connect(gain1.y, sum1.u[1]) annotation (Line(
            points={{49.8,26},{48.6,26},{48.6,20.8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(MedullaNaEffect.yBase, sum1.y)   annotation (Line(
            points={{48,8},{48,11.6}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(inv1.y, ADHEffect.u)  annotation (Line(
            points={{35.8,60},{34,60},{34,62},{32,62}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(inv2.y, MedullaNaEffect.u) annotation (Line(
            points={{61.6,6},{56,6}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(H2OChannels.Active, NephronADHOnPerm.yBase) annotation (Line(
            points={{55.6,-51.4},{66,-51.4},{66,-58},{78,-58},{78,-44},{74,
              -44}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(NephronADHOnPerm.y, PermOnOutflow.u) annotation (Line(
            points={{68,-44},{66,-44},{66,-38}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(PermOnOutflow.y, CollectingDuct.FractReab) annotation (Line(
            points={{62,-30},{30,-30},{30,-20},{36,-20}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(Constant.y, PermOnOutflow.yBase) annotation (Line(
            points={{71.5,-30},{68,-30}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Constant1.y, NephronADHEffect.yBase) annotation (Line(
            points={{44.75,75},{46,75},{46,70}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(NephronADHEffect.y, inv1.u) annotation (Line(
            points={{46,64},{46,60},{40.4,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(LoopOfHenle.FractReab, gain.y) annotation (Line(
            points={{-10.2,-62.6},{-15.82,-62.6},{-15.82,-64},{-19.6,-64}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(CollectingDuct.outflowMin, MedullaNaEffect.y) annotation (
            Line(
            points={{52,-10},{52,2},{48,2}},
            color={0,0,127},
            smooth=Smooth.None));

        //!!!

        connect(busConnector.DT_Na_Outflow, ADHEffect.yBase)       annotation (Line(
            points={{-92,86},{24,86},{24,64}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(gain.u, busConnector.LH_Na_FractReab) annotation (Line(
            points={{-28.8,-64},{-36,-64},{-36,86},{-92,86}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(inv2.u, busConnector.MedullaNa_conc) annotation (Line(
            points={{70.8,6},{96,6},{96,86},{-92,86}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.CD_Glucose_Outflow, gain1.u) annotation (Line(
            points={{-92,86},{96.1,86},{96.1,26},{54.4,26}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.CD_NH4_Outflow, sum1.u[2]) annotation (Line(
            points={{-92,86},{98,86},{98,20.8},{48.2,20.8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.CD_K_Outflow, sum1.u[3]) annotation (Line(
            points={{-92,86},{98,86},{98,20.8},{47.8,20.8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.CD_Na_Outflow, sum1.u[4]) annotation (Line(
            points={{-92,86},{98,86},{98,20.8},{47.4,20.8}},
            color={0,0,127},
            smooth=Smooth.None));

      connect(NephronADHEffect.u, busConnector.Vasopressin) annotation (Line(
          points={{54,68},{78,68},{78,86},{-92,86}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(NephronADHOnPerm.u, busConnector.Vasopressin) annotation (Line(
          points={{72,-52},{96,-52},{96,86},{-92,86}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
        connect(busConnector.GlomerulusBloodPressure, glomerulus.hydraulicPressureIn)
          annotation (Line(
            points={{-92,86},{-92,66},{-64,66}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
      connect(PelvisPressure.y, glomerulus.hydraulicPressureOut) annotation (
          Line(
          points={{-43,74},{-48,74},{-48,66}},
          color={0,0,127},
          smooth=Smooth.None));
        connect(busConnector.GlomerulusFiltrate_GFR, flowMeasure4.volumeFlowRate)
          annotation (Line(
            points={{-92,86},{-92,24},{-50,24}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(busConnector.LH_H2O_Outflow, flowMeasure3.volumeFlowRate) annotation (
           Line(
            points={{-92,86},{-92,-30},{6,-30}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(flowMeasure1.volumeFlowRate, busConnector.CD_H2O_Outflow) annotation (
           Line(
            points={{72,-6},{98,-6},{98,86},{-92,86}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{6,3},{6,3}}));
        connect(CollectingDuct.Reabsorption, H2OChannels.CD_H2O_Reab) annotation (
            Line(
            points={{44,-26},{44,-48}},
            color={127,127,0},
            thickness=1,
            smooth=Smooth.None));
        connect(flowMeasure2.volumeFlowRate, busConnector.CD_H2O_Reab) annotation (
            Line(
            points={{26,-86},{98,-86},{98,86},{-92,86}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{6,3},{6,3}}));
        connect(flowMeasure2.q_in, H2OChannels.q_out) annotation (Line(
            points={{36,-80},{44,-80},{44,-68}},
            color={127,127,0},
            thickness=1,
            smooth=Smooth.None));

        connect(ProximalTubule.FractReab, busConnector.PT_Na_FractReab) annotation (Line(
            points={{-14,52},{-14,86},{-92,86}},
            color={0,0,127},
            smooth=Smooth.None));
      connect(MedullaVolume.y, busConnector.Medulla_Volume) annotation (Line(
          points={{-77,-90},{98,-90},{98,86},{-92,86}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(busConnector.Glomerulus_GFR, flowMeasure4.volumeFlowRate)
        annotation (Line(
          points={{-92,86},{-92,24},{-50,24}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(Perm.y, NephronCountEffect.yBase) annotation (Line(
          points={{-59,94},{-56,94},{-56,80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(NephronCountEffect.y, glomerulus.conduction) annotation (Line(
          points={{-56,74},{-56,66}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.Kidney_NephronCount_Total_xNormal,
        NephronCountEffect.u) annotation (Line(
          points={{-92,86},{-92,78},{-64,78}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
        connect(plasma, glomerulusFlow.port_a) annotation (Line(
            points={{-98,30},{-82,30},{-82,34.4}},
            color={127,127,0},
            thickness=1,
            smooth=Smooth.None));
        connect(glomerulus.q_in, glomerulusFlow.filtrate) annotation (Line(
            points={{-66,58},{-66,44},{-67.8,44}},
            color={127,127,0},
            thickness=1,
            smooth=Smooth.None));
        connect(busConnector.KidneyPlasmaFlow, glomerulusFlow.solutionFlow)
          annotation (Line(
            points={{-92,86},{-92,44},{-85,44}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(flowMeasure4.port_a, ProximalTubule.Inflow) annotation (Line(
            points={{-44,14},{-44,6},{-30,6},{-30,62},{-22,62},{-22,54}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(glomerulus.particlesOutside[1], flowMeasure4.port_b)
          annotation (Line(
            points={{-46,58},{-44,58},{-44,34}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(LoopOfHenle.Outflow, flowMeasure3.port_b) annotation (Line(
            points={{6,-55.4},{12,-55.4},{12,-40}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(flowMeasure3.port_a, distalTubule.port_b) annotation (Line(
            points={{12,-20},{12,46},{14,46}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(distalTubule.port_a, CollectingDuct.Inflow) annotation (Line(
            points={{34,46},{38,46},{38,30},{26,30},{26,-12},{34,-12}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(flowMeasure1.port_a, urine) annotation (Line(
            points={{82,-12},{94,-12},{94,-72},{89,-72}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(CollectingDuct.Outflow, flowMeasure1.port_b) annotation (Line(
            points={{54,-12},{62,-12}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(ProximalTubule.Outflow, LoopOfHenle.Inflow) annotation (Line(
            points={{-22,34},{-22,-55.4},{-12,-55.4}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(LoopOfHenle.Reabsorption, plasma) annotation (Line(
            points={{-3,-68},{-2,-68},{-2,-80},{-98,-80},{-98,30}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(flowMeasure2.port_a, plasma) annotation (Line(
            points={{16,-80},{-98,-80},{-98,30}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(flowMeasure3.port_a, plasma) annotation (Line(
            points={{12,-20},{12,44},{-4,44},{-4,100},{-100,100},{-100,30},{-98,
                30}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(ProximalTubule.Reabsorption, plasma) annotation (Line(
            points={{-8,44},{-4,44},{-4,100},{-100,100},{-100,30},{-98,30}},
            color={158,66,200},
            thickness=1,
            smooth=Smooth.None));
        connect(ADHEffect.y, distalTubule.soluteFlow) annotation (Line(
            points={{24,58},{24,54},{28,54},{28,50}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics));
      end Kidney;

    end Kidney;

  model Peritoneum_const
  extends Physiolibrary.Icons.Peritoneum;

  Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_a
                                                 flux
        "plasma proteins concentration"
                                    annotation (Placement(transformation(
          extent={{56,30},{76,50}}), iconTransformation(extent={{-10,30},{
            10,50}})));

    parameter Physiolibrary.Types.Volume initialVolume(displayUnit="ml") = 0
        "initial water in peritoneum";

  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-106,87},{-86,107}}), iconTransformation(
          extent={{60,60},{80,80}})));

  Physiolibrary.Types.Constants.VolumeFlowRateConst PeritoneumSpace_Change(k=0)
        "Water gain to peritoneum. "
      annotation (Placement(transformation(extent={{-66,-4},{-20,42}})));
  Physiolibrary.Types.Constants.VolumeConst
           PeritoneumSpace_Volume(k=1e-18) "Water in peritoneum. [ml]"
  annotation (Placement(transformation(extent={{-66,48},{-20,94}})));

  equation
    flux.q=0;
    connect(PeritoneumSpace_Volume.y, busConnector.PeritoneumSpace_Vol)
      annotation (Line(
        points={{-14.25,71},{26,71},{26,97},{-96,97}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(PeritoneumSpace_Change.y, busConnector.PeritoneumSpace_Change)
      annotation (Line(
        points={{-14.25,19},{26,19},{26,97},{-96,97}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    annotation (
  Documentation(info="<HTML>
<PRE>
QHP 2008 / Peritoneum
</PRE>
</HTML>
", revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),   Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(
            extent={{-100,120},{100,104}},
            lineColor={0,0,255},
            textString="%name")}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                100,100}}),      graphics));
  end Peritoneum_const;

  model Bladder_steady
   // extends Library.PressureFlow.VolumeCompartement;
    extends Physiolibrary.Icons.Bladder;
  Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a con annotation (
      Placement(transformation(extent={{-84,18},{-44,58}}, rotation=0),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  Physiolibrary.Hydraulic.Sources.UnlimitedOutflowPump
                                                bladderVoidFlow(
      useSolutionFlowInput=true)
    annotation (Placement(transformation(extent={{-58,-23},{-73,-8}})));
  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-100,69},{-80,89}}), iconTransformation(
          extent={{-100,-100},{-80,-80}})));

  Physiolibrary.Types.Constants.VolumeConst volumeConstant(k=0.0003)
    annotation (Placement(transformation(extent={{-28,32},{-20,40}})));
  Physiolibrary.Hydraulic.Sensors.FlowMeasure flowMeasure annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-38,6})));

    Physiolibrary.Hydraulic.Components.ElasticVessel elasticVesselvolumeCompartement(
      stateName="BladderVolume.Mass",
      ZeroPressureVolume(displayUnit="l") = 0.001,
      volume_start=0.0003)
      annotation (Placement(transformation(extent={{-20,54},{0,74}})));
  equation
    connect(con, flowMeasure.q_in) annotation (Line(
        points={{-64,38},{-38,38},{-38,16}},
        color={0,0,0},
        thickness=1,
        smooth=Smooth.None));
    connect(flowMeasure.volumeFlow, busConnector.BladderVoidFlow) annotation (
        Line(
        points={{-50,6},{20,6},{20,79},{-90,79}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
  connect(bladderVoidFlow.q_in, flowMeasure.q_out) annotation (Line(
      points={{-58,-15.5},{-48,-15.5},{-48,-16},{-38,-16},{-38,-4}},
      color={0,0,0},
      thickness=1,
      smooth=Smooth.None));
  connect(busConnector.CD_H2O_Outflow, bladderVoidFlow.solutionFlow)
    annotation (Line(
      points={{-90,79},{-90,8},{-66,8},{-66,-10.25},{-65.5,-10.25}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(con, elasticVesselvolumeCompartement.q_in) annotation (Line(
      points={{-64,38},{-38,38},{-38,64},{-10,64}},
      color={0,0,0},
      thickness=1,
      smooth=Smooth.None));
  connect(elasticVesselvolumeCompartement.volume, busConnector.BladderVolume_Mass)
    annotation (Line(
      points={{-4,54},{-4,44},{20,44},{20,79},{-90,79}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={Text(
            extent={{-100,96},{100,80}},
            lineColor={0,0,255},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics));
  end Bladder_steady;

  model Bladder_steady2
   // extends Library.PressureFlow.VolumeCompartement;
    extends Physiolibrary.Icons.Bladder;
  Physiolibrary.Thermodynamical.Interfaces.ChemicalPort_a     con annotation (
      Placement(transformation(extent={{-84,18},{-44,58}}, rotation=0),
        iconTransformation(extent={{-72,70},{-52,90}})));
  Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePumpOut  bladderVoidFlow(
      useSoluteFlowInput=true)
    annotation (Placement(transformation(extent={{-58,-23},{-73,-8}})));
  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-100,69},{-80,89}}), iconTransformation(
          extent={{-100,-100},{-80,-80}})));

  Physiolibrary.Thermodynamical.Sensors.MolarFlowMeasure   flowMeasure annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-38,6})));

    Physiolibrary.Thermodynamical.Components.Substance bladder(volume_start=0.0003)
      annotation (Placement(transformation(extent={{-26,28},{-6,48}})));
  equation
  connect(busConnector.CD_H2O_Outflow, bladderVoidFlow.solutionFlow)
    annotation (Line(
      points={{-90,79},{-90,8},{-66,8},{-66,-10.25},{-65.5,-10.25}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
    connect(flowMeasure.volumeFlowRate, busConnector.BladerVoidFlow)
      annotation (Line(
        points={{-32,6},{22,6},{22,79},{-90,79}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(bladder.volume, busConnector.BladderVolume_Mass) annotation (Line(
        points={{-10,28},{22,28},{22,79},{-90,79}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(flowMeasure.volumeFlowRate, busConnector.BladderVoidFlow)
      annotation (Line(
        points={{-32,6},{30,6},{30,79},{-90,79}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(con, bladder.port_a) annotation (Line(
          points={{-64,38},{-38,38},{-38,33},{-16,33}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(con, flowMeasure.port_b) annotation (Line(
          points={{-64,38},{-38,38},{-38,16}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
      connect(flowMeasure.port_a, bladderVoidFlow.q_in) annotation (Line(
          points={{-38,-4},{-38,-15.5},{-58,-15.5}},
          color={158,66,200},
          thickness=1,
          smooth=Smooth.None));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
                -100},{100,100}}),
                                 graphics={Text(
            extent={{-100,96},{100,80}},
            lineColor={0,0,255},
            textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics));
  end Bladder_steady2;

    model LungEdema_const
    extends Physiolibrary.Icons.Lungs;

     parameter Real initialVolume(displayUnit="ml") = 0;

    Physiolibrary.Osmotic.Interfaces.OsmoticPort_a q_in(o(final displayUnit=
            "g/ml")) annotation (Placement(transformation(extent={{-110,10},{
              -90,30}}), iconTransformation(extent={{-10,30},{10,50}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-104,61},{-84,81}}), iconTransformation(
            extent={{60,60},{80,80}})));

    Physiolibrary.Types.Constants.VolumeConst volume(k=0)
      annotation (Placement(transformation(extent={{-66,42},{-58,50}})));
    equation
    connect(volume.y, busConnector.ExcessLungWater_Volume) annotation (Line(
        points={{-57,46},{-8,46},{-8,71},{-94,71}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
        annotation (
    Documentation(info="<HTML>
<PRE>
Torso water compartment.
 
</PRE>
</HTML>
",   revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),         graphics), Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics={                                   Text(
              extent={{-100,88},{100,72}},
              lineColor={0,0,255},
              textString="%name")}));
    end LungEdema_const;
  end WaterCompartments;

  package TissuesVolume
    "Division of intracellular and interstitial water into tissues"
    extends Physiolibrary.Icons.Tissues;

    model Tissue
      "compute tissue size from global interstitial and cell H20 volume"

      parameter Physiolibrary.Types.Fraction FractIFV;
      parameter Physiolibrary.Types.Fraction FractOrganH2O;

      Physiolibrary.Types.RealIO.VolumeInput InterstitialWater_Vol
        annotation (Placement(transformation(extent={{-120,60},{-80,100}})));
      Physiolibrary.Types.RealIO.VolumeInput CellH2O_Vol
        annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
      Physiolibrary.Types.RealIO.VolumeOutput LiquidVol
        "all tissue water volume"
        annotation (Placement(transformation(extent={{80,60},{120,100}}),
            iconTransformation(extent={{80,60},{120,100}})));
      Physiolibrary.Types.RealIO.VolumeOutput OrganH2O
        "tissue cells water volume"
        annotation (Placement(transformation(extent={{80,20},{120,60}}),
            iconTransformation(extent={{80,20},{120,60}})));

      Physiolibrary.Types.RealIO.VolumeOutput InterstitialWater
        "tissue interstitial water volume"
        annotation (Placement(transformation(extent={{80,20},{120,60}}),
            iconTransformation(extent={{80,-20},{120,20}})));
    equation
      OrganH2O = FractOrganH2O * CellH2O_Vol;
      LiquidVol = FractIFV*InterstitialWater_Vol + OrganH2O;
      InterstitialWater = LiquidVol - OrganH2O;
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),
                             graphics), Icon(coordinateSystem(preserveAspectRatio=false,
                      extent={{-100,-100},{100,100}}), graphics={
            Text(
              extent={{-72,64},{64,96}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={215,215,215},
              textString="IST .. %FractIFV"),
            Text(
              extent={{-72,26},{64,58}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={215,215,215},
              textString="ICF .. %FractOrganH2O"),
            Text(
              extent={{-98,-104},{102,-120}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0})}));
    end Tissue;

    model Tissues
      import QHP = Physiomodel;
     extends Physiolibrary.Icons.Tissues;
      SkeletalMuscle skeletalMuscle(FractIFV=0.59704112420698, FractOrganH2O=
          0.59704112420698)
        annotation (Placement(transformation(extent={{-54,62},{-34,82}})));
      Bone bone(FractIFV=0.075535107692334, FractOrganH2O=0.075535107692334)
        annotation (Placement(transformation(extent={{-54,36},{-34,56}})));
      Fat fat(FractIFV=0.068679312541595, FractOrganH2O=0.068679312541595)
        annotation (Placement(transformation(extent={{-54,-54},{-34,-34}})));
      Brain brain(FractIFV=0.021385027838153, FractOrganH2O=0.021385027838153)
        annotation (Placement(transformation(extent={{52,28},{72,48}})));
      QHP.Water.TissuesVolume.RightHeart rightHeart(FractIFV=
          0.00071147906305641, FractOrganH2O=0.00071147906305641)
        annotation (Placement(transformation(extent={{52,-92},{72,-72}})));
      RespiratoryMuscle respiratoryMuscle(FractIFV=6.71126519181567e-002,
          FractOrganH2O=6.71126519181567e-002)
        annotation (Placement(transformation(extent={{-54,-24},{-34,-4}})));
      OtherTissue otherTissue(FractIFV=6.70823116596042e-002, FractOrganH2O=6.70823116596042e-002)
        annotation (Placement(transformation(extent={{-54,8},{-34,28}})));
      Liver liver(FractIFV=2.84998184687167e-002, FractOrganH2O=2.84998184687167e-002)
        annotation (Placement(transformation(extent={{52,58},{72,78}})));
      QHP.Water.TissuesVolume.LeftHeart leftHeart(FractIFV=0.0042688743783384,
        FractOrganH2O=0.0042688743783384)
        annotation (Placement(transformation(extent={{52,-62},{72,-42}})));
      QHP.Water.TissuesVolume.Kidney kidney(FractIFV=4.71608978940247e-003,
          FractOrganH2O=4.71608978940247e-003)
        annotation (Placement(transformation(extent={{52,-34},{72,-14}})));
      QHP.Water.TissuesVolume.GITract GITract(FractIFV=2.34991370540916e-002,
          FractOrganH2O=2.34991370540916e-002)
        annotation (Placement(transformation(extent={{52,-2},{72,18}})));
    Physiolibrary.Types.BusConnector busConnector
      annotation (Placement(transformation(extent={{-108,72},{-68,112}})));
      Skin skin(FractIFV=0.041469065389573, FractOrganH2O=0.041469065389573)
        annotation (Placement(transformation(extent={{-54,-84},{-34,-64}})));

    //Real ifv;
    //Real organ;
    equation

      connect(busConnector.InterstitialWater_Vol, bone.InterstitialWater_Vol)      annotation (
         Line(
          points={{-88,92},{-88,54},{-54,54}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));

      connect(busConnector.InterstitialWater_Vol, brain.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,46},{52,46}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, fat.InterstitialWater_Vol)      annotation (
          Line(
          points={{-88,92},{-88,-36},{-54,-36}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, GITract.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,16},{52,16}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, kidney.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-16},{52,-16}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, leftHeart.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-44},{52,-44}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, liver.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,76},{52,76}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, otherTissue.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{-88,26},{-54,26}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, respiratoryMuscle.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{-88,-6},{-54,-6}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, rightHeart.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-74},{52,-74}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, skin.InterstitialWater_Vol)      annotation (
         Line(
          points={{-88,92},{-88,-66},{-54,-66}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.InterstitialWater_Vol, skeletalMuscle.InterstitialWater_Vol)
        annotation (Line(
          points={{-88,92},{-87.5,92},{-87.5,80},{-54,80}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));

      connect(busConnector.CellH2O_Vol, bone.CellH2O_Vol)         annotation (
         Line(
          points={{-88,92},{-88,50},{-54,50}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, brain.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,42},{52,42}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, fat.CellH2O_Vol)         annotation (
          Line(
          points={{-88,92},{-88,-40},{-54,-40}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, GITract.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,12},{52,12}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, kidney.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-20},{52,-20}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, leftHeart.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-48},{52,-48}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, liver.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,72},{52,72}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, otherTissue.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{-88,22},{-54,22}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, respiratoryMuscle.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{-88,-10},{-54,-10}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, rightHeart.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{6,92},{6,-78},{52,-78}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, skin.CellH2O_Vol)         annotation (
         Line(
          points={{-88,92},{-88,-70},{-54,-70}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));
      connect(busConnector.CellH2O_Vol, skeletalMuscle.CellH2O_Vol)
        annotation (Line(
          points={{-88,92},{-87.5,92},{-87.5,76},{-54,76}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,2},{-5,2}}));

      connect(bone.LiquidVol, busConnector.bone_LiquidVol)       annotation (
         Line(
          points={{-34,54},{6,54},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(brain.LiquidVol, busConnector.brain_LiquidVol)
        annotation (Line(
          points={{72,46},{98,46},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(fat.LiquidVol, busConnector.fat_LiquidVol)     annotation (
          Line(
          points={{-34,-36},{6,-36},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(GITract.LiquidVol, busConnector.GITract_LiquidVol)
        annotation (Line(
          points={{72,16},{98,16},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(kidney.LiquidVol, busConnector.kidney_LiquidVol)
        annotation (Line(
          points={{72,-16},{98,-16},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(leftHeart.LiquidVol, busConnector.leftHeart_LiquidVol)
        annotation (Line(
          points={{72,-44},{98,-44},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(liver.LiquidVol, busConnector.liver_LiquidVol)
        annotation (Line(
          points={{72,76},{98,76},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(otherTissue.LiquidVol, busConnector.otherTissue_LiquidVol)
        annotation (Line(
          points={{-34,26},{6,26},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(respiratoryMuscle.LiquidVol, busConnector.respiratoryMuscle_LiquidVol)
        annotation (Line(
          points={{-34,-6},{6,-6},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(rightHeart.LiquidVol, busConnector.rightHeart_LiquidVol)
        annotation (Line(
          points={{72,-74},{98,-74},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skin.LiquidVol, busConnector.skin_LiquidVol)     annotation (
         Line(
          points={{-34,-66},{6,-66},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skeletalMuscle.LiquidVol, busConnector.skeletalMuscle_LiquidVol)
        annotation (Line(
          points={{-34,80},{5.5,80},{5.5,92},{-88,92}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));

     connect(bone.LiquidVol, busConnector.Bone_LiquidVol)       annotation (
         Line(
          points={{-34,54},{6,54},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(brain.LiquidVol, busConnector.Brain_LiquidVol)
        annotation (Line(
          points={{72,46},{98,46},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(fat.LiquidVol, busConnector.Fat_LiquidVol)     annotation (
          Line(
          points={{-34,-36},{6,-36},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(kidney.LiquidVol, busConnector.Kidney_LiquidVol)
        annotation (Line(
          points={{72,-16},{98,-16},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(leftHeart.LiquidVol, busConnector.LeftHeart_LiquidVol)
        annotation (Line(
          points={{72,-44},{98,-44},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(liver.LiquidVol, busConnector.Liver_LiquidVol)
        annotation (Line(
          points={{72,76},{98,76},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(otherTissue.LiquidVol, busConnector.OtherTissue_LiquidVol)
        annotation (Line(
          points={{-34,26},{6,26},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(respiratoryMuscle.LiquidVol, busConnector.RespiratoryMuscle_LiquidVol)
        annotation (Line(
          points={{-34,-6},{6,-6},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(rightHeart.LiquidVol, busConnector.RightHeart_LiquidVol)
        annotation (Line(
          points={{72,-74},{98,-74},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skin.LiquidVol, busConnector.Skin_LiquidVol)     annotation (
         Line(
          points={{-34,-66},{6,-66},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skeletalMuscle.LiquidVol, busConnector.SkeletalMuscle_LiquidVol)
        annotation (Line(
          points={{-34,80},{5.5,80},{5.5,92},{-88,92}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));

      connect(bone.OrganH2O, busConnector.bone_CellH2OVol)       annotation (
         Line(
          points={{-34,50},{6,50},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(brain.OrganH2O, busConnector.brain_CellH2OVol)
        annotation (Line(
          points={{72,42},{98,42},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(fat.OrganH2O, busConnector.fat_CellH2OVol)     annotation (
          Line(
          points={{-34,-40},{6,-40},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(GITract.OrganH2O, busConnector.GITract_CellH2OVol)
        annotation (Line(
          points={{72,12},{98,12},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(kidney.OrganH2O, busConnector.kidney_CellH2OVol)
        annotation (Line(
          points={{72,-20},{98,-20},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(leftHeart.OrganH2O, busConnector.leftHeart_CellH2OVol)
        annotation (Line(
          points={{72,-48},{98,-48},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(liver.OrganH2O, busConnector.liver_CellH2OVol)
        annotation (Line(
          points={{72,72},{98,72},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(otherTissue.OrganH2O, busConnector.otherTissue_CellH2OVol)
        annotation (Line(
          points={{-34,22},{6,22},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(respiratoryMuscle.OrganH2O, busConnector.respiratoryMuscle_CellH2OVol)
        annotation (Line(
          points={{-34,-10},{6,-10},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(rightHeart.OrganH2O, busConnector.rightHeart_CellH2OVol)
        annotation (Line(
          points={{72,-78},{98,-78},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skin.OrganH2O, busConnector.skin_CellH2OVol)     annotation (
         Line(
          points={{-34,-70},{6,-70},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skeletalMuscle.OrganH2O, busConnector.skeletalMuscle_CellH2OVol)
        annotation (Line(
          points={{-34,76},{5.5,76},{5.5,92},{-88,92}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));

     connect(bone.InterstitialWater, busConnector.bone_InterstitialWater)       annotation (
         Line(
          points={{-34,46},{6,46},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(brain.InterstitialWater, busConnector.brain_InterstitialWater)
        annotation (Line(
          points={{72,38},{98,38},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(fat.InterstitialWater, busConnector.fat_InterstitialWater)     annotation (
          Line(
          points={{-34,-44},{6,-44},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(GITract.InterstitialWater, busConnector.GITract_InterstitialWater)
        annotation (Line(
          points={{72,8},{98,8},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(kidney.InterstitialWater, busConnector.kidney_InterstitialWater)
        annotation (Line(
          points={{72,-24},{98,-24},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(leftHeart.InterstitialWater, busConnector.leftHeart_InterstitialWater)
        annotation (Line(
          points={{72,-52},{98,-52},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(liver.InterstitialWater, busConnector.liver_InterstitialWater)
        annotation (Line(
          points={{72,68},{98,68},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(otherTissue.InterstitialWater, busConnector.otherTissue_InterstitialWater)
        annotation (Line(
          points={{-34,18},{6,18},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(respiratoryMuscle.InterstitialWater, busConnector.respiratoryMuscle_InterstitialWater)
        annotation (Line(
          points={{-34,-14},{6,-14},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(rightHeart.InterstitialWater, busConnector.rightHeart_InterstitialWater)
        annotation (Line(
          points={{72,-82},{98,-82},{98,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skin.InterstitialWater, busConnector.skin_InterstitialWater)     annotation (
         Line(
          points={{-34,-74},{6,-74},{6,92},{-88,92}},
          color={0,127,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
      connect(skeletalMuscle.InterstitialWater, busConnector.skeletalMuscle_InterstitialWater)
        annotation (Line(
          points={{-34,72},{5.5,72},{5.5,92},{-88,92}},
          color={127,0,0},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{5,2},{5,2}}));
    //ifv=bone.FractIFV +brain.FractIFV +fat.FractIFV +GITract.FractIFV +kidney.FractIFV +leftHeart.FractIFV +liver.FractIFV +otherTissue.FractIFV +respiratoryMuscle.FractIFV +rightHeart.FractIFV +skin.FractIFV +skeletalMuscle.FractIFV;
    //organ=bone.FractOrganH2O +brain.FractOrganH2O +fat.FractOrganH2O +GITract.FractOrganH2O +kidney.FractOrganH2O +leftHeart.FractOrganH2O +liver.FractOrganH2O +otherTissue.FractOrganH2O +respiratoryMuscle.FractOrganH2O +rightHeart.FractOrganH2O +skin.FractOrganH2O +skeletalMuscle.FractOrganH2O;
    /*
 assert(bone.FractIFV +
brain.FractIFV +
fat.FractIFV +
GITract.FractIFV +
kidney.FractIFV +
leftHeart.FractIFV +
liver.FractIFV +
otherTissue.FractIFV +
respiratoryMuscle.FractIFV +
rightHeart.FractIFV +
skin.FractIFV +
skeletalMuscle.FractIFV <> 1, "Water.TissuesVolume.Tissues: Sum of FractIFV is not 1!");
 assert(bone.FractOrganH2O +
brain.FractOrganH2O +
fat.FractOrganH2O +
GITract.FractOrganH2O +
kidney.FractOrganH2O +
leftHeart.FractOrganH2O +
liver.FractOrganH2O +
otherTissue.FractOrganH2O +
respiratoryMuscle.FractOrganH2O +
rightHeart.FractOrganH2O +
skin.FractOrganH2O +
skeletalMuscle.FractOrganH2O <> 1, "Water.TissuesVolume.Tissues: Sum of FractOrganH20 is not 1!");
*/
      annotation (Icon(graphics={Text(
              extent={{-100,-104},{100,-120}},
              lineColor={0,0,255},
              textString="%name")}),
                               Diagram(coordinateSystem(preserveAspectRatio=true,
                      extent={{-100,-100},{100,100}}), graphics));
    end Tissues;

    model SkeletalMuscle
      extends Physiolibrary.Icons.SkeletalMuscle;
      extends Tissue;
    end SkeletalMuscle;

    model Bone
      extends Physiolibrary.Icons.Bone;
      extends Tissue;
    end Bone;

    model OtherTissue
      extends Physiolibrary.Icons.OtherTissue;
      extends Tissue;
    end OtherTissue;

    model RespiratoryMuscle
      extends Physiolibrary.Icons.RespiratoryMuscle;
      extends Tissue;
    end RespiratoryMuscle;

    model Fat
      extends Physiolibrary.Icons.Fat;
      extends Tissue;
    end Fat;

    model Skin
      extends Physiolibrary.Icons.Skin;
      extends Tissue;
    end Skin;

    model Liver
      extends Physiolibrary.Icons.Liver;
      extends Tissue;
    end Liver;

    model Brain
      extends Physiolibrary.Icons.Brain;
      extends Tissue;
    end Brain;

    model GITract
      extends Physiolibrary.Icons.GITract;
      extends Tissue;
    end GITract;

    model Kidney
      extends Physiolibrary.Icons.Kidney;
      extends Tissue;
    end Kidney;

    model LeftHeart
      extends Physiolibrary.Icons.LeftHeart;
      extends Tissue;
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
                {{-100,-100},{100,100}}), graphics));
    end LeftHeart;

    model RightHeart
      extends Physiolibrary.Icons.RightHeart;
      extends Tissue;
    end RightHeart;
  end TissuesVolume;

  package Skin
    extends Physiolibrary.Icons.Skin;

    model Skin
      extends Physiolibrary.Icons.Skin;
      parameter Real bodyPart=1/3;
    Physiolibrary.Types.Constants.VolumeFlowRateConst flowConstant(k=1*
          bodyPart)
      annotation (Placement(transformation(extent={{62,80},{70,88}})));
    Physiolibrary.Blocks.Factors.Spline NerveEffect(data={{0.0,0.0,0.0},{4.0,
          30.0,0.0}})
      annotation (Placement(transformation(extent={{62,54},{82,74}})));
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-100,81},{-80,101}}), iconTransformation(
            extent={{60,60},{80,80}})));
    Physiolibrary.Blocks.Factors.Normalization FuelEffect
      annotation (Placement(transformation(extent={{62,42},{82,62}})));
    Physiomodel.Metabolism.deprecated.Input2EffectDelayed AcclimationEffect(Tau=6,
        data={{60,0.5,0.0},{85,1.0,0.05},{100,2.0,0.0}})
      annotation (Placement(transformation(extent={{62,22},{82,42}})));
    Physiolibrary.Blocks.Factors.Normalization SkinFunctionEffect
      annotation (Placement(transformation(extent={{62,2},{82,22}})));
      Physiolibrary.NonSIunits.degC_to_degF degC_to_degF
        annotation (Placement(transformation(extent={{48,28},{56,36}})));
      Physiolibrary.Chemical.MassStorageCompartment          SweatFuel(
          initialSoluteMass=1, stateName="SweatFuel.Mass")
        annotation (Placement(transformation(extent={{56,-52},{78,-32}})));
      Physiolibrary.Chemical.InputPump          inputPump
        annotation (Placement(transformation(extent={{34,-52},{54,-32}})));
      Physiolibrary.Chemical.OutputPump          outputPump
        annotation (Placement(transformation(extent={{82,-52},{102,-32}})));
      Modelica.Blocks.Math.Gain gain(k=0.0004) annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={92,-26})));
    Physiolibrary.Blocks.Factors.Spline MassEffect(data={{0.9,1.0,0.0},{1.0,
          0.0,0.0}})
      annotation (Placement(transformation(extent={{34,-38},{54,-18}})));
    Physiolibrary.Types.Constants.DeprecatedUntypedConstant Constant(k=0.004)
      annotation (Placement(transformation(extent={{34,-20},{42,-12}})));
      Modelica.Blocks.Math.Feedback H2OOutflow
        annotation (Placement(transformation(extent={{-2,-12},{-18,4}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab(k=0)
      annotation (Placement(transformation(extent={{-26,-22},{-18,-14}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab1(k=0.37*
          bodyPart)
      annotation (Placement(transformation(extent={{-48,-64},{-40,-56}})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{-28,-82},{-8,-62}})));
      Modelica.Blocks.Logical.Greater greater
        annotation (Placement(transformation(extent={{-70,-82},{-50,-62}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab2(k=0)
      annotation (Placement(transformation(extent={{-74,-98},{-66,-90}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out annotation (
        Placement(transformation(extent={{-48,-44},{-30,-28}}),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    Physiolibrary.Osmotic.Sources.SolventOutflux sweat(useSolutionFlowInput=
          true)
      annotation (Placement(transformation(extent={{-62,-46},{-82,-26}})));
    Physiolibrary.Osmotic.Sources.SolventOutflux vapor(useSolutionFlowInput=
          true)
      annotation (Placement(transformation(extent={{6,-92},{26,-72}})));
      Modelica.Blocks.Interfaces.RealOutput LiquidVol(
                                               final displayUnit="ml")
        "all tissue water volume"
        annotation (Placement(transformation(extent={{90,70},{130,110}}),
            iconTransformation(extent={{80,60},{120,100}})));
    equation
      connect(flowConstant.y, NerveEffect.yBase) annotation (Line(
          points={{71,84},{72,84},{72,66}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.HypothalamusSweating_NA, NerveEffect.u)
        annotation (Line(
          points={{-90,91},{-56,91},{-56,64},{64,64}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(busConnector.skin_FunctionEffect, SkinFunctionEffect.u)
        annotation (Line(
          points={{-90,91},{-56,91},{-56,12},{64,12}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(AcclimationEffect.y, SkinFunctionEffect.yBase) annotation (Line(
          points={{72,30},{72,14}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(NerveEffect.y, FuelEffect.yBase) annotation (Line(
          points={{72,60},{72,54}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(FuelEffect.y, AcclimationEffect.yBase) annotation (Line(
          points={{72,50},{72,34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.skin_T, degC_to_degF.degC) annotation (Line(
          points={{-90,91},{-56,91},{-56,32},{47.2,32}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(degC_to_degF.degF, AcclimationEffect.u) annotation (Line(
          points={{56.8,32},{62.2,32}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SweatFuel.soluteMass, FuelEffect.u) annotation (Line(
          points={{67,-49.4},{67,-58},{22,-58},{22,52},{62.2,52}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(inputPump.q_out, SweatFuel.q_out) annotation (Line(
          points={{50,-42},{67,-42}},
          color={200,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(SweatFuel.q_out, outputPump.q_in) annotation (Line(
          points={{67,-42},{86,-42}},
          color={200,0,0},
          thickness=1,
          smooth=Smooth.None));
      connect(gain.y, outputPump.desiredFlow) annotation (Line(
          points={{92,-30.4},{92,-38}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(MassEffect.y, inputPump.desiredFlow) annotation (Line(
          points={{44,-30},{44,-38}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SweatFuel.soluteMass, MassEffect.u) annotation (Line(
          points={{67,-49.4},{67,-58},{22,-58},{22,-28},{34.2,-28}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Constant.y, MassEffect.yBase) annotation (Line(
          points={{43,-16},{44,-16},{44,-26}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SkinFunctionEffect.y, H2OOutflow.u1) annotation (Line(
          points={{72,8},{72,-4},{-3.6,-4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OReab.y, H2OOutflow.u2) annotation (Line(
          points={{-17,-18},{-10,-18},{-10,-10.4}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SkinFunctionEffect.y, gain.u) annotation (Line(
          points={{72,8},{72,-4},{92,-4},{92,-21.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(greater.y, switch1.u2) annotation (Line(
          points={{-49,-72},{-30,-72}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(H2OReab1.y, switch1.u1) annotation (Line(
          points={{-39,-60},{-36,-60},{-36,-64},{-30,-64}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OReab2.y, switch1.u3) annotation (Line(
          points={{-65,-94},{-34,-94},{-34,-80},{-30,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OReab2.y, greater.u2) annotation (Line(
          points={{-65,-94},{-60,-94},{-60,-86},{-76,-86},{-76,-80},{-72,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.skin_BloodFlow, greater.u1) annotation (Line(
          points={{-90,91},{-90,-72},{-72,-72}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(vapor.q_in, q_out) annotation (Line(
          points={{10,-82},{4,-82},{4,-36},{-39,-36}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
      connect(sweat.q_in, q_out) annotation (Line(
          points={{-66,-36},{-39,-36}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
    connect(switch1.y, vapor.solutionFlow) annotation (Line(
        points={{-7,-72},{16,-72},{16,-75}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(H2OOutflow.y, sweat.solutionFlow) annotation (Line(
        points={{-17.2,-4},{-72,-4},{-72,-29}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),       graphics), Icon(coordinateSystem(
              preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
            graphics={Text(
              extent={{-155,-83},{126,-108}},
              lineColor={0,0,255},
              textString="%name")}));
    end Skin;

    model SweatGland
      extends Physiolibrary.Icons.SweatGland;
      parameter Real bodyPart=1/3;
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-100,81},{-80,101}}), iconTransformation(
            extent={{60,60},{80,80}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out annotation (
        Placement(transformation(extent={{-48,-44},{-30,-28}}),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    Physiolibrary.Osmotic.Sources.SolventOutflux sweat(useSolutionFlowInput=
          true)
      annotation (Placement(transformation(extent={{-62,-46},{-82,-26}})));
    Physiolibrary.Types.Constants.FractionConst             fractConstant(k=
          bodyPart)
      annotation (Placement(transformation(extent={{-92,-4},{-66,22}})));
    Physiolibrary.Blocks.Factors.Normalization BodyPart
      annotation (Placement(transformation(extent={{-44,18},{-24,38}})));
    equation
      connect(sweat.q_in, q_out) annotation (Line(
          points={{-66,-36},{-39,-36}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
      connect(busConnector.SweatDuct_H2OOutflow, BodyPart.yBase) annotation (
          Line(
          points={{-90,91},{-34,91},{-34,30}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(fractConstant.y, BodyPart.u) annotation (Line(
          points={{-62.75,9},{-53.35,9},{-53.35,28},{-42,28}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(BodyPart.y, sweat.solutionFlow) annotation (Line(
        points={{-34,24},{-36,24},{-36,-20},{-72,-20},{-72,-29}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),       graphics), Icon(coordinateSystem(
              preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
            graphics={Text(
              extent={{-137,-103},{144,-128}},
              lineColor={0,0,255},
              textString="%name")}));
    end SweatGland;

    model InsensibleSkin
      extends Physiolibrary.Icons.Skin;
      parameter Real bodyPart=1/3;
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-100,81},{-80,101}}), iconTransformation(
            extent={{60,60},{80,80}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab1(k=0.37*
          bodyPart)
      annotation (Placement(transformation(extent={{-48,-64},{-40,-56}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out annotation (
        Placement(transformation(extent={{-48,-44},{-30,-28}}),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    Physiolibrary.Osmotic.Sources.SolventOutflux vapor(useSolutionFlowInput=
          true)
      annotation (Placement(transformation(extent={{6,-92},{26,-72}})));
    equation
      connect(vapor.q_in, q_out) annotation (Line(
          points={{10,-82},{4,-82},{4,-36},{-39,-36}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
    connect(H2OReab1.y, vapor.solutionFlow) annotation (Line(
        points={{-39,-60},{16,-60},{16,-78}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),       graphics), Icon(coordinateSystem(
              preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
            graphics={Text(
              extent={{-155,-83},{126,-108}},
              lineColor={0,0,255},
              textString="%name")}));
    end InsensibleSkin;

    model InsensibleSkin2
      extends Physiolibrary.Icons.Skin;
      parameter Real bodyPart=1/3;
    Physiolibrary.Types.BusConnector busConnector annotation (Placement(
          transformation(extent={{-100,81},{-80,101}}), iconTransformation(
            extent={{60,60},{80,80}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab1(k=0.37*
          bodyPart)
      annotation (Placement(transformation(extent={{-48,-64},{-40,-56}})));
      Modelica.Blocks.Logical.Switch switch1
        annotation (Placement(transformation(extent={{-28,-82},{-8,-62}})));
      Modelica.Blocks.Logical.Greater greater
        annotation (Placement(transformation(extent={{-70,-82},{-50,-62}})));
    Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab2(k=0)
      annotation (Placement(transformation(extent={{-74,-98},{-66,-90}})));
    Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out annotation (
        Placement(transformation(extent={{-48,-44},{-30,-28}}),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    Physiolibrary.Osmotic.Sources.SolventOutflux vapor(useSolutionFlowInput=
          true)
      annotation (Placement(transformation(extent={{6,-92},{26,-72}})));
    equation
      connect(greater.y, switch1.u2) annotation (Line(
          points={{-49,-72},{-30,-72}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(H2OReab1.y, switch1.u1) annotation (Line(
          points={{-39.6,-60},{-36,-60},{-36,-64},{-30,-64}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OReab2.y, switch1.u3) annotation (Line(
          points={{-65.6,-94},{-34,-94},{-34,-80},{-30,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(H2OReab2.y, greater.u2) annotation (Line(
          points={{-65.6,-94},{-60,-94},{-60,-86},{-76,-86},{-76,-80},{-72,
              -80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(busConnector.skin_BloodFlow, greater.u1) annotation (Line(
          points={{-90,91},{-90,-72},{-72,-72}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(vapor.q_in, q_out) annotation (Line(
          points={{10,-82},{4,-82},{4,-36},{-39,-36}},
          color={127,127,0},
          thickness=1,
          smooth=Smooth.None));
    connect(switch1.y, vapor.solutionFlow) annotation (Line(
        points={{-7,-72},{16,-72},{16,-78}},
        color={0,0,127},
        smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}),       graphics), Icon(coordinateSystem(
              preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
            graphics={Text(
              extent={{-155,-83},{126,-108}},
              lineColor={0,0,255},
              textString="%name")}));
    end InsensibleSkin2;

    package test
      model SweatGland
        extends Physiolibrary.Icons.SweatGland;
        parameter Real bodyPart=1/3;
      Physiolibrary.Types.Constants.VolumeFlowRateConst flowConstant(k=1*
            bodyPart)
        annotation (Placement(transformation(extent={{62,80},{70,88}})));
      Physiolibrary.Blocks.Factors.Spline NerveEffect(data={{0.0,0.0,0.0},{
            4.0,30.0,0.0}})
        annotation (Placement(transformation(extent={{62,54},{82,74}})));
      Physiolibrary.Types.BusConnector busConnector annotation (Placement(
            transformation(extent={{-100,81},{-80,101}}), iconTransformation(
              extent={{60,60},{80,80}})));
      Physiolibrary.Blocks.Factors.Normalization FuelEffect
        annotation (Placement(transformation(extent={{62,42},{82,62}})));
      Physiomodel.Metabolism.deprecated.Input2EffectDelayed AcclimationEffect(
        Tau=6,
        data={{60,0.5,0.0},{85,1.0,0.05},{100,2.0,0.0}},
        stateName="SweatAcclimation.Effect")
        annotation (Placement(transformation(extent={{62,22},{82,42}})));
      Physiolibrary.Blocks.Factors.Normalization SkinFunctionEffect
        annotation (Placement(transformation(extent={{62,2},{82,22}})));
        Physiolibrary.NonSIunits.degC_to_degF degC_to_degF
          annotation (Placement(transformation(extent={{48,28},{56,36}})));
        Physiolibrary.Chemical.MassStorageCompartment          SweatFuel(
            initialSoluteMass=1, stateName="SweatFuel.Mass")
          annotation (Placement(transformation(extent={{56,-52},{78,-32}})));
        Physiolibrary.Chemical.InputPump          inputPump
          annotation (Placement(transformation(extent={{34,-52},{54,-32}})));
        Physiolibrary.Chemical.OutputPump          outputPump
          annotation (Placement(transformation(extent={{82,-52},{102,-32}})));
        Modelica.Blocks.Math.Gain gain(k=0.0004) annotation (Placement(
              transformation(
              extent={{-4,-4},{4,4}},
              rotation=270,
              origin={92,-26})));
      Physiolibrary.Blocks.Factors.Spline MassEffect(data={{0.9,1.0,0.0},{1.0,
            0.0,0.0}})
        annotation (Placement(transformation(extent={{34,-38},{54,-18}})));
      Physiolibrary.Types.Constants.DeprecatedUntypedConstant Constant(k=
            0.004)
        annotation (Placement(transformation(extent={{34,-20},{42,-12}})));
        Modelica.Blocks.Math.Feedback H2OOutflow
          annotation (Placement(transformation(extent={{-2,-12},{-18,4}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst H2OReab(k=0)
        annotation (Placement(transformation(extent={{-26,-22},{-18,-14}})));
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out annotation (
          Placement(transformation(extent={{-48,-44},{-30,-28}}),
            iconTransformation(extent={{-90,-50},{-70,-30}})));
      Physiolibrary.Osmotic.Sources.SolventOutflux sweat(useSolutionFlowInput=
           true)
        annotation (Placement(transformation(extent={{-62,-46},{-82,-26}})));
      Physiolibrary.Types.Constants.DeprecatedUntypedConstant fractConstant(k=
           bodyPart)
        annotation (Placement(transformation(extent={{-94,-4},{-68,22}})));
      Physiolibrary.Blocks.Factors.Normalization BodyPart
        annotation (Placement(transformation(extent={{-44,18},{-24,38}})));
      equation
        connect(flowConstant.y, NerveEffect.yBase) annotation (Line(
            points={{70.4,84},{72,84},{72,66}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.HypothalamusSweating_NA, NerveEffect.u)
          annotation (Line(
            points={{-90,91},{-56,91},{-56,64},{62.2,64}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(busConnector.skin_FunctionEffect, SkinFunctionEffect.u)
          annotation (Line(
            points={{-90,91},{-56,91},{-56,12},{62.2,12}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(AcclimationEffect.y, SkinFunctionEffect.yBase) annotation (Line(
            points={{72,30},{72,14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(NerveEffect.y, FuelEffect.yBase) annotation (Line(
            points={{72,62},{72,54}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(FuelEffect.y, AcclimationEffect.yBase) annotation (Line(
            points={{72,50},{72,34}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(busConnector.skin_T, degC_to_degF.degC) annotation (Line(
            points={{-90,91},{-56,91},{-56,32},{47.2,32}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(degC_to_degF.degF, AcclimationEffect.u) annotation (Line(
            points={{56.8,32},{62.2,32}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(SweatFuel.soluteMass, FuelEffect.u) annotation (Line(
            points={{67,-49.4},{67,-58},{22,-58},{22,52},{62.2,52}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(inputPump.q_out, SweatFuel.q_out) annotation (Line(
            points={{50,-42},{67,-42}},
            color={200,0,0},
            thickness=1,
            smooth=Smooth.None));
        connect(SweatFuel.q_out, outputPump.q_in) annotation (Line(
            points={{67,-42},{86,-42}},
            color={200,0,0},
            thickness=1,
            smooth=Smooth.None));
        connect(gain.y, outputPump.desiredFlow) annotation (Line(
            points={{92,-30.4},{92,-38}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(MassEffect.y, inputPump.desiredFlow) annotation (Line(
            points={{44,-30},{44,-38}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(SweatFuel.soluteMass, MassEffect.u) annotation (Line(
            points={{67,-49.4},{67,-58},{22,-58},{22,-28},{34.2,-28}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Constant.y, MassEffect.yBase) annotation (Line(
            points={{42.4,-16},{44,-16},{44,-26}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(SkinFunctionEffect.y, H2OOutflow.u1) annotation (Line(
            points={{72,10},{72,-4},{-3.6,-4}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(H2OReab.y, H2OOutflow.u2) annotation (Line(
            points={{-17.6,-18},{-10,-18},{-10,-10.4}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(SkinFunctionEffect.y, gain.u) annotation (Line(
            points={{72,10},{72,-4},{92,-4},{92,-21.2}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(sweat.q_in, q_out) annotation (Line(
            points={{-66,-36},{-39,-36}},
            color={127,127,0},
            thickness=1,
            smooth=Smooth.None));
      connect(H2OOutflow.y, sweat.solutionFlow) annotation (Line(
          points={{-17.2,-4},{-72,-4},{-72,-32}},
          color={0,0,127},
          smooth=Smooth.None));
        connect(busConnector.SweatDuct_H2OOutflow, BodyPart.yBase)
          annotation (Line(
            points={{-90,91},{-34,91},{-34,30}},
            color={0,0,255},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(fractConstant.y, BodyPart.u) annotation (Line(
            points={{-66.7,9},{-53.35,9},{-53.35,28},{-43.8,28}},
            color={0,0,127},
            smooth=Smooth.None));
      connect(BodyPart.y, sweat.solutionFlow) annotation (Line(
          points={{-34,26},{-36,26},{-36,-20},{-72,-20},{-72,-32}},
          color={0,0,127},
          smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}),       graphics), Icon(coordinateSystem(
                preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
              graphics={Text(
                extent={{-137,-103},{144,-128}},
                lineColor={0,0,255},
                textString="%name")}));
      end SweatGland;
    end test;
  end Skin;

  model InsensibleLungs
    extends Physiolibrary.Icons.Lungs;
  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-84,67},{-64,87}}), iconTransformation(extent=
           {{60,60},{80,80}})));
    Modelica.Blocks.Math.Product product
      annotation (Placement(transformation(extent={{-44,34},{-24,54}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{-44,2},{-24,22}})));
    Modelica.Blocks.Math.Division division
      annotation (Placement(transformation(extent={{28,-10},{48,10}})));
    Modelica.Blocks.Math.Product product1
      annotation (Placement(transformation(extent={{-10,8},{10,28}})));
  Physiolibrary.Types.Constants.PressureConst pressureConstant(k=
        6266.152208505)
    annotation (Placement(transformation(extent={{-66,16},{-58,24}})));
  Physiolibrary.Types.Constants.DeprecatedUntypedConstant Constant(k=0.80E-3)
    annotation (Placement(transformation(extent={{-64,56},{-56,64}})));
  Physiolibrary.Osmotic.Sources.SolventOutflux vapor(useSolutionFlowInput=
        true)
    annotation (Placement(transformation(extent={{64,-36},{84,-16}})));
  Physiolibrary.Osmotic.Interfaces.OsmoticPort_b q_out
    annotation (Placement(transformation(extent={{-36,-36},{-16,-16}})));
  equation
    connect(busConnector.BarometerPressure, division.u2) annotation (Line(
        points={{-74,77},{-74,-6},{26,-6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(product1.y, division.u1) annotation (Line(
        points={{11,18},{18,18},{18,6},{26,6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(feedback.y, product1.u2) annotation (Line(
        points={{-25,12},{-12,12}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pressureConstant.y, feedback.u1) annotation (Line(
        points={{-57,20},{-50,20},{-50,12},{-42,12}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.EnvironmentRelativeHumidity, feedback.u2)
      annotation (Line(
        points={{-74,77},{-74,4},{-34,4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(product.y, product1.u1) annotation (Line(
        points={{-23,44},{-18,44},{-18,24},{-12,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.BreathingTotalVentilation, product.u2) annotation (
        Line(
        points={{-74,77},{-74,38},{-46,38}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(Constant.y, product.u1) annotation (Line(
        points={{-55,60},{-52,60},{-52,50},{-46,50}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(vapor.q_in, q_out) annotation (Line(
        points={{68,-26},{-26,-26}},
        color={127,127,0},
        thickness=1,
        smooth=Smooth.None));
  connect(division.y, vapor.solutionFlow) annotation (Line(
      points={{49,0},{74,0},{74,-19}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}),      graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={Text(
            extent={{-153,-59},{128,-84}},
            lineColor={0,0,255},
            textString="%name")}));
  end InsensibleLungs;

  model WaterProperties
  extends Physiolibrary.Icons.Water;
    Osmoles.OsmBody osmBody(ECFV(start=14600)) "intra/extracellular water"
      annotation (Placement(transformation(extent={{-84,-22},{-64,-2}})));
    Hydrostatics.Hydrostatics hydrostatics
      annotation (Placement(transformation(extent={{-62,62},{-38,86}})));
    Modelica.Blocks.Math.Feedback sub
      annotation (Placement(transformation(extent={{-4,4},{4,-4}},
          rotation=90,
          origin={-34,4})));
  Physiolibrary.Blocks.Math.Parts CellH2O(nout=3, w={0.2,0.5,0.3})
    annotation (Placement(transformation(extent={{-28,22},{-16,34}})));
    Modelica.Blocks.Math.Sum BodyH2O1(nin=9)
      annotation (Placement(transformation(extent={{74,-50},{66,-42}})));
  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-12,34},{0,46}}), iconTransformation(extent={
            {-118,62},{-80,100}})));
    TissuesVolume.Tissues tissues
      annotation (Placement(transformation(extent={{-70,15},{-50,35}})));
    Modelica.Blocks.Math.Sum InterstitialWater(nin=3)
      annotation (Placement(transformation(extent={{4,-4},{-4,4}},
          rotation=180,
          origin={48,54})));
    Modelica.Blocks.Math.Sum ExternalH2O(nin=3)
      annotation (Placement(transformation(extent={{4,-4},{-4,4}},
          rotation=180,
          origin={54,26})));
    Modelica.Blocks.Math.Sum IntravascularVol(nin=2)
      annotation (Placement(transformation(extent={{4,-4},{-4,4}},
          rotation=180,
          origin={74,-8})));
    Modelica.Blocks.Math.Sum ExtravascularVol(nin=3)
      annotation (Placement(transformation(extent={{4,-4},{-4,4}},
          rotation=180,
          origin={74,8})));
    Modelica.Blocks.Math.Sum BodyH2O(nin=2)
      annotation (Placement(transformation(extent={{62,-38},{54,-30}})));
    Modelica.Blocks.Math.Sum BodyH2O_Gain(nin=4)
      annotation (Placement(transformation(extent={{28,-66},{44,-50}})));
    Modelica.Blocks.Math.Feedback BodyH2O_Change
      annotation (Placement(transformation(extent={{62,-74},{82,-54}})));
    Modelica.Blocks.Math.Sum BodyH2O_Loss(nin=8)
      annotation (Placement(transformation(extent={{38,-96},{54,-80}})));
    Modelica.Blocks.Math.Sum sweatDuct(nin=3)
      annotation (Placement(transformation(extent={{14,75},{30,91}})));
    Modelica.Blocks.Math.Sum insensibleSkin(nin=3)
      annotation (Placement(transformation(extent={{72,68},{88,84}})));
    Modelica.Blocks.Math.Add3 ICFVOsmoles(k1=0.89)
      annotation (Placement(transformation(extent={{-54,-43},{-40,-29}})));
    Physiolibrary.Types.Constants.AmountOfSubstanceConst OsmCell_UnknownOsmoles(k=0.354)
      annotation (Placement(transformation(extent={{-80,-46},{-72,-38}})));
    Modelica.Blocks.Math.Product vaporFlow
    annotation (Placement(transformation(extent={{-24,-86},{-16,-78}})));
    Modelica.Blocks.Math.Feedback pressureDrop
    annotation (Placement(transformation(extent={{-56,-71},{-44,-59}})));
    Modelica.Blocks.Math.Division H2OFraction
    annotation (Placement(transformation(extent={{-38,-77},{-30,-69}})));
  Physiolibrary.Types.Constants.PressureConst pressureConstant(k=
        6266.152208505)
    annotation (Placement(transformation(extent={{-76,-62},{-68,-54}})));
  Physiolibrary.Types.Constants.FractionConst             Constant(k(
        displayUnit="1") = 0.0008)
    annotation (Placement(transformation(extent={{-90,-96},{-82,-88}})));
    Modelica.Blocks.Math.Product HeatInsensibleLung_H2O
    annotation (Placement(transformation(extent={{-66,-99},{-58,-91}})));
  Osmoles.ActiveOsmolesFake2 activeOsmolesFake
    annotation (Placement(transformation(extent={{16,-39},{36,-19}})));
  equation
    connect(osmBody.ICFV, sub.u1)      annotation (Line(
        points={{-63.6,-4},{-34,-4},{-34,0.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sub.y, CellH2O.u)      annotation (Line(
        points={{-34,7.6},{-34,28},{-29.2,28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(CellH2O.y[1], busConnector.UT_Cell_H2O)  annotation (Line(
        points={{-15.4,27.6},{-12,24},{-6,24},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(CellH2O.y[2], busConnector.MT_Cell_H2O)  annotation (Line(
        points={{-15.4,28},{-6,28},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(CellH2O.y[3], busConnector.LT_Cell_H2O)  annotation (Line(
        points={{-15.4,28.4},{-12,32},{-6,32},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(osmBody.OsmBody_Osm_conc_CellWalls, busConnector.OsmBody_Osm_conc_CellWalls)
      annotation (Line(
        points={{-63.6,-12},{-6,-12},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.Status_Posture, hydrostatics.Status_Posture)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,83.6},{-60.8,83.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.SystemicArtys_Pressure, hydrostatics.SystemicArtys_Pressure)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,71.6},{-60.8,71.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.RightAtrium_Pressure, hydrostatics.RightAtrium_Pressure)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,76.4},{-60.8,76.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.LegMusclePump_Effect, hydrostatics.LegMusclePump_Effect)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,64.4},{-60.8,64.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.OsmECFV_Electrolytes, osmBody.OsmECFV_Electrolytes)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,-2},{-82.8,-2}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.OsmCell_Electrolytes, osmBody.OsmCell_Electrolytes)
      annotation (Line(
        points={{-6,40},{-86,40},{-86,-6},{-82.8,-6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.RBCH2O_Vol, sub.u2)              annotation (Line(
        points={{-6,40},{-86,40},{-86,4},{-37.2,4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));

    connect(busConnector, tissues.busConnector)         annotation (Line(
        points={{-6,40},{-6,39},{-68.8,39},{-68.8,34.2}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
    connect(sub.y, busConnector.CellH2O_Vol)              annotation (Line(
        points={{-34,7.6},{-34,40},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(InterstitialWater.y, busConnector.InterstitialWater_Vol)
      annotation (Line(
        points={{52.4,54},{100,54},{100,40},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(osmBody.ECFV, busConnector.ECFV_Vol)         annotation (Line(
        points={{-63.6,-8},{-6,-8},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));

    connect(osmBody.ICFV, busConnector.ICFV_Vol) annotation (Line(
        points={{-63.6,-4},{-6,-4},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(osmBody.Osmoreceptors, busConnector.Osmreceptors) annotation (
        Line(
        points={{-63.6,-16},{-6,-16},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(busConnector.UreaECF_Osmoles, osmBody.UreaECF) annotation (Line(
        points={{-6,40},{-86,40},{-86,-10},{-82.8,-10}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.UreaICF_Osmoles, osmBody.UreaICF) annotation (Line(
        points={{-6,40},{-86,40},{-86,-14},{-82.8,-14}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.GlucoseECF_Osmoles, osmBody.GlucoseECF) annotation (Line(
        points={{-6,40},{-86,40},{-86,-18},{-82.8,-18}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));

  /*  connect(busConnector.ExcessLungWater_Volume, BodyH2O.u[6]) annotation (Line(
      points={{-6,40},{88,40},{88,-25.5429},{32.8,-25.5429}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(busConnector.PeritoneumSpace_Vol, BodyH2O.u[7]) annotation (Line(
      points={{-6,40},{88,40},{88,-25.3143},{32.8,-25.3143}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
*/

    connect(busConnector.ExcessLungWater_Volume, ExternalH2O.u[1]) annotation (
        Line(
        points={{-6,40},{14,40},{14,30},{44,30},{44,26.5333},{49.2,26.5333}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,6},{-6,6}}));
    connect(busConnector.GILumenVolume_Mass, ExternalH2O.u[2]) annotation (Line(
        points={{-6,40},{14,40},{14,26},{49.2,26}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,2},{-6,2}}));
    connect(busConnector.PeritoneumSpace_Vol, ExternalH2O.u[3]) annotation (Line(
        points={{-6,40},{14,40},{14,20},{44,20},{44,25.4667},{49.2,25.4667}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-3},{-6,-3}}));
    connect(busConnector.PlasmaVol, IntravascularVol.u[1]) annotation (Line(
        points={{-6,40},{14,40},{14,-6},{66,-6},{66,-7.6},{69.2,-7.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.RBCH2O_Vol, IntravascularVol.u[2]) annotation (Line(
        points={{-6,40},{14,40},{14,-12},{66,-12},{66,-8.4},{69.2,-8.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-2},{-6,-2}}));
    connect(ExternalH2O.y, ExtravascularVol.u[1]) annotation (Line(
        points={{58.4,26},{66,26},{66,8.53333},{69.2,8.53333}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.CellH2O_Vol, ExtravascularVol.u[2]) annotation (Line(
        points={{-6,40},{14,40},{14,10},{66,10},{66,8},{69.2,8}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.InterstitialWater_Vol, ExtravascularVol.u[3])
      annotation (Line(
        points={{-6,40},{14,40},{14,4},{66,4},{66,7.46667},{69.2,7.46667}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-2},{-6,-2}}));

    connect(ExtravascularVol.y, BodyH2O.u[1]) annotation (Line(
        points={{78.4,8},{84,8},{84,-34.4},{62.8,-34.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(IntravascularVol.y, BodyH2O.u[2]) annotation (Line(
        points={{78.4,-8},{82,-8},{82,-33.6},{62.8,-33.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(BodyH2O_Gain.y, BodyH2O_Change.u1) annotation (Line(
        points={{44.8,-58},{54,-58},{54,-64},{64,-64}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(BodyH2O_Loss.y, BodyH2O_Change.u2) annotation (Line(
        points={{54.8,-88},{72,-88},{72,-72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.GILumenVolume_Intake, BodyH2O_Gain.u[1]) annotation (
        Line(
        points={{-6,40},{-6,-56},{26,-56},{26,-59.2},{26.4,-59.2}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,5},{-6,5}}));
    connect(busConnector.MetabolicH2O_Rate, BodyH2O_Gain.u[2]) annotation (Line(
        points={{-6,40},{-6,-58},{28,-58},{28,-58.4},{26.4,-58.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,2},{-6,2}}));
    connect(busConnector.IVDrip_H2ORate, BodyH2O_Gain.u[3]) annotation (Line(
        points={{-6,40},{-6,-60},{26,-60},{26,-57.6},{26.4,-57.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-1},{-6,-1}}));
    connect(busConnector.Transfusion_H2ORate, BodyH2O_Gain.u[4]) annotation (
        Line(
        points={{-6,40},{-6,-62},{26,-62},{26,-56.8},{26.4,-56.8}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-4},{-6,-4}}));
    connect(busConnector.CD_H2O_Outflow, BodyH2O_Loss.u[1]) annotation (Line(
        points={{-6,40},{-6,-79},{36.4,-79},{36.4,-89.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,12},{-6,12}}));
    connect(busConnector.SweatDuct_H2OOutflow, BodyH2O_Loss.u[2]) annotation (
        Line(
        points={{-6,40},{-6,-82},{36,-82},{36.4,-89}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,9},{-6,9}}));
    connect(busConnector.Hemorrhage_H2ORate, BodyH2O_Loss.u[3]) annotation (Line(
        points={{-6,40},{-6,-84},{36.4,-84},{36.4,-88.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,6},{-6,6}}));
    connect(busConnector.DialyzerActivity_UltrafiltrationRate, BodyH2O_Loss.u[4])
      annotation (Line(
        points={{-6,40},{-6,-87},{36.4,-87},{36.4,-88.2}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.HeatInsensibleSkin_H2O, BodyH2O_Loss.u[5]) annotation (
        Line(
        points={{-6,40},{-6,-89},{36.4,-89},{36.4,-87.8}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,0},{-6,0}}));
    connect(busConnector.HeatInsensibleLung_H2O, BodyH2O_Loss.u[6]) annotation (
        Line(
        points={{-6,40},{-6,-92},{36.4,-92},{36.4,-87.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-3},{-6,-3}}));
    connect(busConnector.GILumenVomitus_H2OLoss, BodyH2O_Loss.u[7]) annotation (
        Line(
        points={{-6,40},{-6,-94},{36.4,-94},{36.4,-87}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-6},{-6,-6}}));
    connect(busConnector.GILumenDiarrhea_H2OLoss, BodyH2O_Loss.u[8]) annotation (
        Line(
        points={{-6,40},{-6,-97},{36.4,-97},{36.4,-86.6}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,-9},{-6,-9}}));
    connect(insensibleSkin.y, busConnector.HeatInsensibleSkin_H2O)
      annotation (Line(
        points={{88.8,76},{92,76},{92,63},{0,63},{0,40},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(sweatDuct.y, busConnector.SweatGland_H2ORate) annotation (Line(
        points={{30.8,83},{100,83},{100,40},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(ICFVOsmoles.y, busConnector.OsmBody_ICFVActiveOsmoles) annotation (
        Line(
        points={{-39.3,-36},{-6,-36},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(busConnector.OsmCell_Electrolytes, ICFVOsmoles.u1) annotation (Line(
        points={{-6,40},{-86,40},{-86,-30.4},{-55.4,-30.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.UreaICF_Osmoles, ICFVOsmoles.u2) annotation (Line(
        points={{-6,40},{-86,40},{-86,-36},{-55.4,-36}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(OsmCell_UnknownOsmoles.y, ICFVOsmoles.u3) annotation (Line(
        points={{-71,-42},{-66,-42},{-66,-41.6},{-55.4,-41.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.UT.Sweat_H2OOutflow, sweatDuct.u[1]) annotation (
        Line(
        points={{-6,40},{-6,82},{12.4,82},{12.4,81.9333}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.MT.Sweat_H2OOutflow, sweatDuct.u[2]) annotation (
        Line(
        points={{-6,40},{-6,83},{12.4,83}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.LT.Sweat_H2OOutflow, sweatDuct.u[3]) annotation (
        Line(
        points={{-6,40},{-6,84.0667},{12.4,84.0667}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.UT.InsensibleSkin_H2O, insensibleSkin.u[1])
      annotation (Line(
        points={{-6,40},{-6,70},{70,70},{70,74.9333},{70.4,74.9333}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.MT.InsensibleSkin_H2O, insensibleSkin.u[2])
      annotation (Line(
        points={{-6,40},{-6,71},{70,71},{70,76},{70.4,76}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.LT.InsensibleSkin_H2O, insensibleSkin.u[3])
      annotation (Line(
        points={{-6,40},{-6,72},{70,72},{70,77.0667},{70.4,77.0667}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.UT.InterstitialWater_Vol, InterstitialWater.u[1])
      annotation (Line(
        points={{-6,40},{24,40},{24,54.5333},{43.2,54.5333}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(busConnector.MT.InterstitialWater_Vol, InterstitialWater.u[2])
      annotation (Line(
        points={{-6,40},{24,40},{24,54},{43.2,54}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
    connect(busConnector.LT.InterstitialWater_Vol, InterstitialWater.u[3])
      annotation (Line(
        points={{-6,40},{24,40},{24,53.4667},{43.2,53.4667}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
    connect(hydrostatics.RegionalPressure_UpperCapy, busConnector.UT.CapillaryRegionalPressure)
      annotation (Line(
        points={{-38,77.6},{-6,77.6},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.PlasmaVol,BodyH2O1. u[1])   annotation (Line(
        points={{-6,40},{100,40},{100,-29},{74.8,-29},{74.8,-46.7111}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.RBCH2O_Vol, BodyH2O1.u[5]) annotation (Line(
        points={{-6,40},{88,40},{88,-46},{74.8,-46}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
    connect(busConnector.LT.InterstitialWater_Vol,BodyH2O1. u[2])  annotation (Line(
        points={{-6,40},{100,40},{100,-46.5333},{74.8,-46.5333}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.MT.InterstitialWater_Vol,BodyH2O1. u[3])  annotation (Line(
        points={{-6,40},{100,40},{100,-46.3556},{74.8,-46.3556}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.UT.InterstitialWater_Vol,BodyH2O1. u[4])  annotation (Line(
        points={{-6,40},{100,40},{100,-46.1778},{74.8,-46.1778}},
        color={0,0,127},
        smooth=Smooth.None));
     connect(busConnector.LT_Cell_H2O,BodyH2O1. u[7])  annotation (Line(
        points={{-6,40},{100,40},{100,-45.6444},{74.8,-45.6444}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.MT_Cell_H2O,BodyH2O1. u[8])  annotation (Line(
        points={{-6,40},{100,40},{100,-45.4667},{74.8,-45.4667}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(busConnector.UT.Cell_H2O,BodyH2O1. u[9])  annotation (Line(
        points={{-6,40},{100,40},{100,-45.2889},{74.8,-45.2889}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(ExternalH2O.y, BodyH2O1.u[6]) annotation (Line(
        points={{58.4,26},{100,26},{100,-45.8222},{74.8,-45.8222}},
        color={0,0,127},
        smooth=Smooth.None));
  connect(busConnector.BarometerPressure, H2OFraction.u2) annotation (Line(
      points={{-6,40},{-86,40},{-86,-75.4},{-38.8,-75.4}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(pressureConstant.y, pressureDrop.u1) annotation (Line(
      points={{-67,-58},{-60,-58},{-60,-65},{-54.8,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(busConnector.BreathingTotalVentilation, vaporFlow.u2) annotation (
      Line(
      points={{-6,40},{-86,40},{-86,-84.4},{-24.8,-84.4}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(pressureDrop.y, H2OFraction.u1) annotation (Line(
      points={{-44.6,-65},{-42,-65},{-42,-70},{-40,-70},{-40,-70.6},{-38.8,
          -70.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(H2OFraction.y, vaporFlow.u1) annotation (Line(
      points={{-29.6,-73},{-28,-73},{-28,-79.6},{-24.8,-79.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Constant.y, HeatInsensibleLung_H2O.u2) annotation (Line(
      points={{-81,-92},{-74,-92},{-74,-97.4},{-66.8,-97.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vaporFlow.y, HeatInsensibleLung_H2O.u1) annotation (Line(
      points={{-15.6,-82},{-14,-82},{-14,-88},{-72,-88},{-72,-92.6},{-66.8,-92.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(busConnector.EnviromentRelativeHumidity_VaporPressure, pressureDrop.u2)
    annotation (Line(
      points={{-6,40},{-86,40},{-86,-69.8},{-50,-69.8}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
    connect(hydrostatics.RegionalPressure_MiddleCapy, busConnector.MT.CapillaryRegionalPressure)
      annotation (Line(
        points={{-38,72.8},{-6,72.8},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(hydrostatics.RegionalPressure_LowerCapy, busConnector.LT.CapillaryRegionalPressure)
      annotation (Line(
        points={{-38,68},{-6,68},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HeatInsensibleLung_H2O.y, busConnector.HeatInsensibleLung_H2O)
      annotation (Line(
        points={{-57.6,-95},{-6,-95},{-6,40}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
  connect(busConnector, activeOsmolesFake.busConnector) annotation (Line(
      points={{-6,40},{6,40},{6,-20.9},{16.1,-20.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(osmBody.ECFVOsmolarity, busConnector.ECFVOsmolarity) annotation (
      Line(
      points={{-63.6,-20},{-6,-20},{-6,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(BodyH2O1.y, osmBody.BodyH2O_Vol) annotation (Line(
      points={{65.6,-46},{-16,-46},{-16,-47},{-98,-47},{-98,-22},{-82.8,-22}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(BodyH2O1.y, busConnector.BodyH2O_Vol) annotation (Line(
      points={{65.6,-46},{-6,-46},{-6,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}},
          grid={2,1}),                graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          grid={2,1}), graphics={Text(
            extent={{-110,-103},{132,-137}},
            lineColor={0,0,255},
            textString="%name")}),
      Documentation(revisions="<html>

<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p>Author:</p></td>
<td><p>Marek Matejak</p></td>
</tr>
<tr>
<td><p>Design:</p></td>
<td><p>Zuzana Rubaninska</p></td>
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
<td><p>2009</p></td>
</tr>
<tr>
<td><p>References:</p></td>
<td><p>Tom Coleman: QHP 2008 beta 3, University of Mississippi Medical Center</p></td>
</tr>
</table>
<br/><p>Copyright &copy; 2014 Marek Matejak</p><br/>

</html>",   info="<html>
<p>Distribution of H2O in whole body:</p>
<p><ul>
<li>blood plasma</li>
<li>erythrocytes</li>
<li>upper torso interstitium</li>
<li>midle torso interstitium</li>
<li>lower torso interstitium</li>
<li>intracellular water (constant fraction coeficient in different tissues(torsos))</li>
</ul></p>
<p><br/>Water redistribution flows:</p>
<p><ul>
<li>semipermeable capilary walls (plasma - GIT/interstitium/glomerulus filtrate)</li>
<li>lymph from upper/lower/midle torso</li>
<li>kidney nephron filtration/reabsorbtion</li>
</ul></p>
<p><br/>driving by hydraulic, hydrostatic and coloid osmotic pressures.</p>
</html>"));
  end WaterProperties;

  model Water
    import QHP = Physiomodel;
    extends Physiolibrary.Icons.Water;
  //  extends Physiomodel.Library.Utilities.DynamicState(stateName="BodyH2O.Vol", initType=Library.Utilities.Init.NoInit, STEADY=false);

  Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePumpOut Hemorrhage(
      useSoluteFlowInput=true)
    annotation (Placement(transformation(extent={{16,47},{32,63}})));
  Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePump Transfusion(
      useSoluteFlowInput=true)
    annotation (Placement(transformation(extent={{32,34},{16,50}})));
  Physiolibrary.Thermodynamical.Sources.UnlimitedSolutePump IVDrip(useSoluteFlowInput=
        true) annotation (Placement(transformation(extent={{32,21},{16,37}})));
  Physiolibrary.Types.BusConnector busConnector annotation (Placement(
        transformation(extent={{-99,80},{-79,100}}), iconTransformation(
          extent={{60,60},{80,80}})));
  QHP.Water2.WaterCompartments.Torso UpperTorso(
    LungFract=0,
    InterstitialPressureVolumeData={{600.0,-30.0,0.01},{2000.0,-4.8,0.0004},{
        5000.0,0.0,0.0004},{12000.0,50.0,0.01}},
    InterstitialWater_start=0.00227,
    IntracellularWater_start=0.00498,
    NormalLymphFlow=6.6666666666667e-09,
    CapillaryConductance(displayUnit="l/(kPa.d)") = 1.4814814814815e-11,
    ICFVFract=0.94,
    SizeFract=0.2,
    CalsFract=0.3,
    SweatFract=0.33,
    SkinFract=0.33)
    annotation (Placement(transformation(extent={{21,-31},{41,-11}})));
  //  interstitiumProteins=3.3,
  QHP.Water2.WaterCompartments.GI_Absorption GILumen
    annotation (Placement(transformation(extent={{-56,54},{-36,74}})));
  QHP.Water2.WaterCompartments.Kidney.Kidney Kidney
    annotation (Placement(transformation(extent={{-51,-67},{-31,-47}})));
    QHP.Water2.WaterCompartments.Bladder_steady2             Bladder
      annotation (Placement(transformation(extent={{-26,-97},{-6,-77}})));
    QHP.Water2.WaterProperties waterProperties
      annotation (Placement(transformation(extent={{-80,-89},{-60,-69}})));

  //  Real bodyH2O;
  /*initial equation 
  if STEADY then
     waterProperties.BodyH2O_Change.y = 0;
  end if;
*/

  //initial equation
  //   bodyH2O = waterProperties.BodyH2O.y;
  Physiolibrary.Thermodynamical.Components.Substance plasma(
      useImpermeableSolutesInput=true,
    NumberOfMembraneTypes=2,
    volume_start=0.00302,
      useSolutionAmountInput=true)
      "Plasma water with two membrane types: capillary (index 1) and cell membrane (index 2)"
    annotation (Placement(transformation(extent={{-27,-5},{-7,15}})));
  QHP.Water2.WaterCompartments.Torso MiddleTorso(
    InterstitialPressureVolumeData={{1200.0,-30.0,0.01},{4800.0,-4.8,0.0004},
        {12000.0,0.0,0.0004},{24000.0,50.0,0.01}},
    InterstitialWater_start=0.00567,
    IntracellularWater_start=0.01246,
    NormalLymphFlow=1.3333333333333e-08,
    CapillaryConductance(displayUnit="l/(kPa.d)") = 3.7268518518519e-11,
    ICFVFract=0.94,
    SizeFract=0.5,
    CalsFract=0.5,
    SweatFract=0.34,
    SkinFract=0.34,
    LungFract=1)
    annotation (Placement(transformation(extent={{22,-62},{42,-42}})));
  QHP.Water2.WaterCompartments.Torso LowerTorso(
    LungFract=0,
    InterstitialPressureVolumeData={{600.0,-30.0,0.02},{3000.0,-4.8,0.0004},{
        4000.0,-4.0,0.0004},{6000.0,50.0,0.03}},
    InterstitialWater_start=0.0034,
    IntracellularWater_start=0.00747,
    NormalLymphFlow=2.1666666666667e-08,
    CapillaryConductance(displayUnit="l/(kPa.d)") = 1.5509259259259e-11,
    ICFVFract=0.94,
    SizeFract=0.3,
    CalsFract=0.2,
    SweatFract=0.33,
    SkinFract=0.33)
    annotation (Placement(transformation(extent={{21,-90},{41,-70}})));
  //  interstitiumProteins=2.2,
  QHP.Water2.WaterCompartments.Peritoneum_const      peritoneum_const(
      initialVolume=1e-09)
    annotation (Placement(transformation(extent={{74,-17},{94,3}})));
  QHP.Hormones.ADH aDH
    annotation (Placement(transformation(extent={{-11,59},{9,79}})));
  QHP.Water2.WaterCompartments.LungEdema lungEdema
    annotation (Placement(transformation(extent={{73,18},{93,38}})));
  Physiolibrary.Thermodynamical.Components.Substance erythrocytes(
    amount_start=0.002, useSolutionAmountInput=true) "Water of red cells"
    annotation (Placement(transformation(extent={{-78,19},{-58,39}})));
  Physiolibrary.Thermodynamical.Components.Membrane RBCmembrane(cond(displayUnit=
          "ml/(kPa.min)") = 1.6666666666667e-08)
    annotation (Placement(transformation(extent={{-52,20},{-32,40}})));
  equation
  //   changePerMin = waterProperties.BodyH2O_Change.y;
  //   stateValue = bodyH2O;

    connect(busConnector, Kidney.busConnector) annotation (Line(
        points={{-89,90},{-89,-49.4},{-47,-49.4}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));

    connect(busConnector, GILumen.busConnector) annotation (Line(
        points={{-89,90},{-89,64},{-55.6,64}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
    connect(Bladder.busConnector, busConnector) annotation (Line(
        points={{-25,-96},{-89,-96},{-89,90}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
  connect(plasma.volume, busConnector.PlasmaVol) annotation (Line(
      points={{-11,-5},{-89,-5},{-89,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(plasma.volume, busConnector.PlasmaVol_Vol) annotation (Line(
      points={{-11,-5},{-89,-5},{-89,90}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(busConnector, waterProperties.busConnector) annotation (Line(
        points={{-89,90},{-89,-70.9},{-79.9,-70.9}},
        color={0,0,255},
        thickness=0.5,
        smooth=Smooth.None));
  connect(UpperTorso.torsoSpecific, busConnector.UT) annotation (Line(
      points={{35,-19},{65,-19},{65,90},{-89,90}},
      color={170,255,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(UpperTorso.busConnector, busConnector) annotation (Line(
      points={{35,-13},{65,-13},{65,90},{-89,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(MiddleTorso.torsoSpecific, busConnector.MT) annotation (Line(
      points={{36,-50},{65,-50},{65,90},{-89,90}},
      color={170,255,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(LowerTorso.torsoSpecific, busConnector.LT) annotation (Line(
      points={{35,-78},{65,-78},{65,90},{-89,90}},
      color={170,255,255},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(LowerTorso.busConnector, busConnector) annotation (Line(
      points={{35,-72},{65,-72},{65,90},{-89,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(MiddleTorso.busConnector, busConnector) annotation (Line(
      points={{36,-44},{65,-44},{65,90},{-89,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(peritoneum_const.busConnector, busConnector) annotation (Line(
      points={{91,0},{96,0},{96,91},{-89,91},{-89,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(busConnector, aDH.busConnector) annotation (Line(
      points={{-89,90},{-13,90},{-13,63},{-9,63}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(lungEdema.busConnector, busConnector) annotation (Line(
      points={{90,35},{96,35},{96,91},{-89,91},{-89,90}},
      color={0,0,255},
      thickness=0.5,
      smooth=Smooth.None));
    connect(RBCmembrane.particlesInside[1], erythrocytes.port_a) annotation (
        Line(
        points={{-52,30},{-61,30},{-61,24},{-68,24}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(RBCmembrane.particlesOutside[1], plasma.port_a) annotation (Line(
        points={{-32,30},{-17,30},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(Hemorrhage.q_in, plasma.port_a) annotation (Line(
        points={{16,55},{6,55},{6,42},{-17,42},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(Transfusion.q_out, plasma.port_a) annotation (Line(
        points={{16,42},{-17,42},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(IVDrip.q_out, plasma.port_a) annotation (Line(
        points={{16,29},{6,29},{6,42},{-17,42},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(Hemorrhage.soluteFlow, busConnector.Hemorrhage_H2ORate) annotation (
       Line(
        points={{27.2,58.2},{27.2,59},{62,59},{62,90},{-89,90}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(Transfusion.soluteFlow, busConnector.Transfusion_H2ORate)
      annotation (Line(
        points={{20.8,45.2},{21,45.2},{21,46},{62,46},{62,90},{-89,90}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(IVDrip.soluteFlow, busConnector.IVDrip_H2ORate) annotation (Line(
        points={{20.8,32.2},{20.8,33},{62,33},{62,90},{-89,90}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(GILumen.vascularH2O, plasma.port_a) annotation (Line(
        points={{-36,64},{-17,64},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(plasma.port_a, UpperTorso.vascularH2O) annotation (Line(
        points={{-17,0},{-17,-17},{25,-17},{25,-21}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(plasma.port_a, MiddleTorso.vascularH2O) annotation (Line(
        points={{-17,0},{-17,-17},{3,-17},{3,-52},{26,-52}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(plasma.port_a, LowerTorso.vascularH2O) annotation (Line(
        points={{-17,0},{-17,-17},{3,-17},{3,-80},{25,-80}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(Kidney.plasma, plasma.port_a) annotation (Line(
        points={{-37,-57},{-28,-57},{-28,0},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(Bladder.con, Kidney.urine) annotation (Line(
        points={{-22.2,-79},{-41,-79},{-41,-67}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(lungEdema.q_in, plasma.port_a) annotation (Line(
        points={{83,32},{71,32},{71,13},{-17,13},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    connect(peritoneum_const.flux, plasma.port_a) annotation (Line(
        points={{84,-3},{71,-3},{71,13},{-17,13},{-17,0}},
        color={158,66,200},
        thickness=1,
        smooth=Smooth.None));
    annotation (
  Documentation(info="<HTML>
<PRE>
QHP 2008 / H2O Reference
 
Created : 26-Jun-06
Last Modified : 24-Mar-08
Author : Tom Coleman
Copyright : 2008-2008
By : University of Mississippi Medical Center
Solver : DES 2005
Schema : 2005.0
 
There are several different ways to describe the body's
water compartments while implementing mass balance.
 
Water compartments can initially be divided into two
basic types: intracellular (ICFV) and extracellular (ECFV).
 
Intracellular compartments are red blood cells and
(all other) cells.
 
Extracellular compartments are plasma and interstitium.
 
Red Cells     =  1.6
Cells         = 26.4
                -----
ICFV          = 28.0
 
Interstitium  = 12.0
Plasma        =  3.0
                -----
ECFV          = 15.0
 
Total         = 43.0
 
The problem with this scheme is that water cannot move
freely between plasma and interstitium but it can move
freely between interstitium and cell H2O.
 
So, we'll divide the body's water compartments into
vascular and extravascular. The vascular compartment
is futher subdivided into RBC water and plasma.
 
Red Cells     =  1.6
Plasma        =  3.0
                 ---
Vascular      =  4.6
 
Cells         = 26.4 (ICFV less RBC's H2O)
Interstitium  = 12.0
                ----
Extravascular = 38.4
 
Total         = 43.0
 
To relax the nomenclature a bit, extravascular water
is referred to as tissue H2O.
 
This scheme is implemented using three integrals: plasma,
RBC and extravascular.
 
Exchanges are internal and external.
 
Internal exchanges are capillary
filtration and lymph flow.
 
External exchanges are many: absorption
from gut, urine, IV drip, transfusion,
hemorrhage ...
 
External exchanges influence the derivative
of either plasma or extravasular H2O.
 
Traditional compartments are also
represented here.
 
Red Cell H2O  =  1584
Organ H2O     = 26428
                -----
Cell H2O      = 28012
 
IFV           = 11988
Plasma        =  3000
                -----
Extracellular = 14988
 
Total         = 43000
</PRE>
</HTML>
", revisions="<html>
<ul>
<li><i>  </i>
       </li>
<li><i> january 2009 </i><br> 
       by Marek Matejak in Modelica initially implemented (consulted with Jiri Kofranek), Charles University, Prague<br>
       orginaly described by Tom Coleman in QHP 2008 beta 3, University of Mississippi Medical Center
       </li>
</ul>
</html>"),
     Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{
              100,100}},
          grid={1,1}),                graphics), Icon(coordinateSystem(
            preserveAspectRatio=true, extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={Text(
            extent={{-139,-99},{142,-124}},
            lineColor={0,0,255},
            textString="%name")}));
  end Water;

  package IO_Bus
      extends Physiolibrary.Types.IO_Bus;
    redeclare model extends Variables

    T.Volume BladderVolume_Mass(varName="BladderVolume.Mass")
        "Urine volume in bladder."
    annotation (Placement(transformation(extent={{-90,-138},{-84,-132}})));
    T.Volume BodyH2O_Vol(varName="BodyH2O.Vol") "Body water volume."
    annotation (Placement(transformation(extent={{-90,-128},{-84,-122}})));
    T.Volume bone_InterstitialWater(varName="Bone-Size.IFV")
        "Bone interstitial water volume."
    annotation (Placement(transformation(extent={{-90,-118},{-84,-112}})));
    T.Volume Bone_LiquidVol(varName="Bone-Size.LiquidVol")
        "Bone water volume = sum of bone interstitial and bone intracellular water."
    annotation (Placement(transformation(extent={{-90,-108},{-84,-102}})));

    T.Volume brain_InterstitialWater(varName="Brain-Size.IFV")
        "Brain interstitial water volume."
    annotation (Placement(transformation(extent={{-90,-98},{-84,-92}})));
    T.Volume Brain_LiquidVol(varName="Brain-Size.LiquidVol")
        "Brain water volume = sum of brain interstitial and brain intracellular water."
    annotation (Placement(transformation(extent={{-90,-88},{-84,-82}})));

    T.VolumeFlowRate CD_H2O_Outflow(varName="CD_H2O.Outflow")
        "Collecting duct water outflow to urine."
    annotation (Placement(transformation(extent={{-90,-78},{-84,-72}})));
    T.VolumeFlowRate CD_H2O_Reab(varName="CD_H2O.Reab")
        "Collecting duct water reabsorbtion."
    annotation (Placement(transformation(extent={{-90,-68},{-84,-62}})));
    T.Volume CellH2O_Vol(varName="CellH2O.Vol") "Intracellular water volume."
    annotation (Placement(transformation(extent={{-90,-58},{-84,-52}})));
    T.Volume ECFV_Vol(varName="ECFV.Vol") "Extracellular fluid volume."
    annotation (Placement(transformation(extent={{-90,-48},{-84,-42}})));
    T.Volume ExcessLungWater_Volume(varName="ExcessLungWater.Volume")
        "Pulmonary edema water."
    annotation (Placement(transformation(extent={{-90,-38},{-84,-32}})));
    T.Volume fat_InterstitialWater(varName="Fat-Size.IFV")
        "Fat interstitial water volume."
    annotation (Placement(transformation(extent={{-90,-28},{-84,-22}})));
    T.Volume Fat_LiquidVol(varName="Fat-Size.LiquidVol")
        "Fat water volume = sum of fat interstitial and fat intracellular water."
    annotation (Placement(transformation(extent={{-90,-18},{-84,-12}})));

    T.VolumeFlowRate GILumenVolume_Absorption(varName="GILumenVolume.Absorption")
        "Water absorbtion through intestines."
    annotation (Placement(transformation(extent={{-90,-8},{-84,-2}})));
    T.VolumeFlowRate GILumenVolume_Intake(varName="GILumenVolume.Intake")
        "Water intake to intestines."
    annotation (Placement(transformation(extent={{-90,2},{-84,8}})));
    T.Volume GILumenVolume_Mass(varName="GILumenVolume.Mass")
        "Water in intestines."
    annotation (Placement(transformation(extent={{-90,12},{-84,18}})));
    T.Volume GITract_InterstitialWater(varName="GITract-Size.IFV")
        "GITract interstitial water volume."
    annotation (Placement(transformation(extent={{-90,22},{-84,28}})));
    T.Volume GITract_LiquidVol(varName="GITract-Size.LiquidVol")
        "GITract water volume = sum of gITract interstitial and gITract intracellular water."
    annotation (Placement(transformation(extent={{-90,32},{-84,38}})));

    T.VolumeFlowRate GlomerulusFiltrate_GFR(varName="GlomerulusFiltrate.GFR")
        "Glomerulus filtration rate."
    annotation (Placement(transformation(extent={{-90,42},{-84,48}})));
    T.VolumeFlowRate Glomerulus_GFR(varName="GlomerulusFiltrate.GFR")
        "Glomerulus filtration rate."
    annotation (Placement(transformation(extent={{-90,52},{-84,58}})));
    T.VolumeFlowRate HeatInsensibleLung_H2O(varName="HeatInsensibleLung.H2O")
        "Vaporized water outflow by breathing."
    annotation (Placement(transformation(extent={{-90,62},{-84,68}})));
    T.VolumeFlowRate HeatInsensibleSkin_H2O(varName="HeatInsensibleSkin.H2O")
        "Vaporized water outflow from skin."
    annotation (Placement(transformation(extent={{-90,72},{-84,78}})));
    T.Volume ICFV_Vol(varName="ICFV.Vol") "Intracellular water volume."
    annotation (Placement(transformation(extent={{-90,82},{-84,88}})));
    T.Volume kidney_InterstitialWater(varName="Kidney-Size.IFV")
        "Kidney interstitial water volume."
    annotation (Placement(transformation(extent={{-90,92},{-84,98}})));
    T.Volume Kidney_LiquidVol(varName="Kidney-Size.LiquidVol")
        "Kidney water volume = sum of kidney interstitial and kidney intracellular water."
    annotation (Placement(transformation(extent={{-90,102},{-84,108}})));

    T.VolumeFlowRate LH_H2O_Outflow(varName="LH_H2O.Outflow")
        "Water outflow from loop of Henle to distal tubule."
    annotation (Placement(transformation(extent={{-90,112},{-84,118}})));
    T.Volume LT_InterstitialWater_Vol(varName="LT_InterstitialWater.Vol")
        "Lower torso interstitial water."
    annotation (Placement(transformation(extent={{-90,122},{-84,128}})));
    T.VolumeFlowRate LT_LymphFlow(varName="LT_LymphWater.Rate")
        "Flow of lymph water from lower torso."
    annotation (Placement(transformation(extent={{-90,132},{-84,138}})));
    T.Volume leftHeart_InterstitialWater(varName="LeftHeart-Size.IFV")
        "LeftHeart interstitial water volume."
    annotation (Placement(transformation(extent={{88,-148},{94,-142}})));
    T.Volume LeftHeart_LiquidVol(varName="LeftHeart-Size.LiquidVol")
        "LeftHeart water volume = sum of leftHeart interstitial and leftHeart intracellular water."
    annotation (Placement(transformation(extent={{88,-138},{94,-132}})));

    T.Volume liver_InterstitialWater(varName="Liver-Size.IFV")
        "Liver interstitial water volume."
    annotation (Placement(transformation(extent={{88,-128},{94,-122}})));
    T.Volume Liver_LiquidVol(varName="Liver-Size.LiquidVol")
        "Liver water volume = sum of liver interstitial and liver intracellular water."
    annotation (Placement(transformation(extent={{88,-118},{94,-112}})));

    T.Volume MT_InterstitialWater_Vol(varName="MT_InterstitialWater.Vol")
        "Middle torso interstitional water."
    annotation (Placement(transformation(extent={{88,-108},{94,-102}})));
    T.VolumeFlowRate MT_LymphFlow(varName="MT_LymphWater.Rate")
        "Middle torso lymph flow."
    annotation (Placement(transformation(extent={{88,-98},{94,-92}})));
    T.Volume Medulla_Volume(varName="Medulla.Volume")
        "Kidney medulla interstitial water volume."
    annotation (Placement(transformation(extent={{88,-88},{94,-82}})));
    T.Osmolarity Osmreceptors(varName="OsmBody.[Osm]-Osmoreceptors", storeUnit="osm/l")
        "Osmolarity in hypothalamic osmoreceptors."
    annotation (Placement(transformation(extent={{88,-78},{94,-72}})));
    T.Volume otherTissue_InterstitialWater(varName="OtherTissue-Size.IFV")
        "OtherTissue interstitial water volume."
    annotation (Placement(transformation(extent={{88,-68},{94,-62}})));
    T.Volume OtherTissue_LiquidVol(varName="OtherTissue-Size.LiquidVol")
        "OtherTissue water volume = sum of otherTissue interstitial and otherTissue intracellular water."
    annotation (Placement(transformation(extent={{88,-58},{94,-52}})));

    T.VolumeFlowRate PeritoneumSpace_Change(varName="PeritoneumSpace.Change")
        "Water inflow(outflow) to pericardium interstitial space."
      annotation (Placement(transformation(extent={{88,-38},{94,-32}})));
    T.Volume PeritoneumSpace_Vol(varName="PeritoneumSpace.Volume")
        "Water in pericardium interstitial space."
    annotation (Placement(transformation(extent={{88,-28},{94,-22}})));
    T.Volume PlasmaVol(varName="PlasmaVol.Vol") "Plasma volume."
    annotation (Placement(transformation(extent={{88,-18},{94,-12}})));
    T.Volume PlasmaVol_Vol(varName="PlasmaVol.Vol") "Plasma volume."
    annotation (Placement(transformation(extent={{88,-8},{94,-2}})));
    T.Volume respiratoryMuscle_InterstitialWater(varName="RespiratoryMuscle-Size.IFV")
        "RespiratoryMuscle interstitial water volume."
    annotation (Placement(transformation(extent={{88,2},{94,8}})));
    T.Volume RespiratoryMuscle_LiquidVol(varName="RespiratoryMuscle-Size.LiquidVol")
        "RespiratoryMuscle water volume = sum of respiratoryMuscle interstitial and respiratoryMuscle intracellular water."
    annotation (Placement(transformation(extent={{88,12},{94,18}})));

    T.Volume rightHeart_InterstitialWater(varName="RightHeart-Size.IFV")
        "RightHeart interstitial water volume."
    annotation (Placement(transformation(extent={{88,22},{94,28}})));
    T.Volume RightHeart_LiquidVol(varName="RightHeart-Size.LiquidVol")
        "RightHeart water volume = sum of rightHeart interstitial and rightHeart intracellular water."
    annotation (Placement(transformation(extent={{88,32},{94,38}})));

    T.Volume skeletalMuscle_InterstitialWater(varName="SkeletalMuscle-Size.IFV")
        "SkeletalMuscle interstitial water volume."
    annotation (Placement(transformation(extent={{88,42},{94,48}})));
    T.Volume SkeletalMuscle_LiquidVol(varName="SkeletalMuscle-Size.LiquidVol")
        "SkeletalMuscle water volume = sum of skeletalMuscle interstitial and skeletalMuscle intracellular water."
    annotation (Placement(transformation(extent={{88,52},{94,58}})));

    T.Volume skin_InterstitialWater(varName="Skin-Size.IFV")
        "Skin interstitial water volume."
    annotation (Placement(transformation(extent={{88,62},{94,68}})));
    T.Volume Skin_LiquidVol(varName="Skin-Size.LiquidVol")
        "Skin water volume = sum of skin interstitial and skin intracellular water."
    annotation (Placement(transformation(extent={{88,72},{94,78}})));

    T.Volume UT_InterstitialWater_Vol(varName="UT_InterstitialWater.Vol")
        "Upper tissue interstitial water."
    annotation (Placement(transformation(extent={{88,92},{94,98}})));
    T.VolumeFlowRate UT_LymphFlow(varName="UT_LymphWater.Rate")
        "Upper tissue lypmh outflow."
    annotation (Placement(transformation(extent={{88,102},{94,108}})));
    T.VolumeFlowRate BladderVoidFlow(varName="BladderVoidFlow")
    annotation (Placement(transformation(extent={{-164,-138},{-158,-132}})));

    T.Concentration Vasopressin(varName="ADHPool.[ADH(pMol/L)]", storeUnit=
          "pmol/l") "Vasopressin extracellular concentration."
      annotation (Placement(transformation(extent={{-104,-150},{-98,-144}})));

    T.VolumeFlowRate SweatGland_H2ORate(varName="SweatGland.H2ORate")
        "Outflow of sweat gland water."
    annotation (Placement(transformation(extent={{-90,150},{-84,156}})));
    T.Volume Liver_CellH2O(varName="Liver-Size.CellH2O")
        "Liver intracellular water volume."
    annotation (Placement(transformation(extent={{-224,0},{-218,6}})));
    T.Volume RespiratoryMuscle_CellH2O(varName="RespiratoryMuscle-Size.CellH2O")
        "Respiratory muscle intracellular water volume."
    annotation (Placement(transformation(extent={{-214,10},{-208,16}})));
    T.Volume SkeletalMuscle_CellH2O(varName="SkeletalMuscle-Size.CellH2O")
        "Skeletal muscle intracellular water volume."
    annotation (Placement(transformation(extent={{-226,20},{-220,26}})));
    equation

    connect(BladderVolume_Mass.y, busConnector.BladderVolume_Mass) annotation (Line(
     points={{-83.7,-135},{90,-135},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(BodyH2O_Vol.y, busConnector.BodyH2O_Vol) annotation (Line(
     points={{-83.7,-125},{90,-125},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(bone_InterstitialWater.y, busConnector.bone_InterstitialWater) annotation (Line(
     points={{-83.7,-115},{90,-115},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Bone_LiquidVol.y, busConnector.Bone_LiquidVol) annotation (Line(
     points={{-83.7,-105},{90,-105},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(brain_InterstitialWater.y, busConnector.brain_InterstitialWater) annotation (Line(
     points={{-83.7,-95},{90,-95},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Brain_LiquidVol.y, busConnector.Brain_LiquidVol) annotation (Line(
     points={{-83.7,-85},{90,-85},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(CD_H2O_Outflow.y, busConnector.CD_H2O_Outflow) annotation (Line(
     points={{-83.7,-75},{90,-75},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(CD_H2O_Reab.y, busConnector.CD_H2O_Reab) annotation (Line(
     points={{-83.7,-65},{90,-65},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(CellH2O_Vol.y, busConnector.CellH2O_Vol) annotation (Line(
     points={{-83.7,-55},{90,-55},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(ECFV_Vol.y, busConnector.ECFV_Vol) annotation (Line(
     points={{-83.7,-45},{90,-45},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(ExcessLungWater_Volume.y, busConnector.ExcessLungWater_Volume) annotation (Line(
     points={{-83.7,-35},{90,-35},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(fat_InterstitialWater.y, busConnector.fat_InterstitialWater) annotation (Line(
     points={{-83.7,-25},{90,-25},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Fat_LiquidVol.y, busConnector.Fat_LiquidVol) annotation (Line(
     points={{-83.7,-15},{90,-15},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GILumenVolume_Absorption.y, busConnector.GILumenVolume_Absorption) annotation (Line(
     points={{-83.7,-5},{90,-5},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GILumenVolume_Intake.y, busConnector.GILumenVolume_Intake) annotation (Line(
     points={{-83.7,5},{90,5},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GILumenVolume_Mass.y, busConnector.GILumenVolume_Mass) annotation (Line(
     points={{-83.7,15},{90,15},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GITract_InterstitialWater.y, busConnector.GITract_InterstitialWater) annotation (Line(
     points={{-83.7,25},{90,25},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GITract_LiquidVol.y, busConnector.GITract_LiquidVol) annotation (Line(
     points={{-83.7,35},{90,35},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(GlomerulusFiltrate_GFR.y, busConnector.GlomerulusFiltrate_GFR) annotation (Line(
     points={{-83.7,45},{90,45},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Glomerulus_GFR.y, busConnector.Glomerulus_GFR) annotation (Line(
     points={{-83.7,55},{90,55},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(HeatInsensibleLung_H2O.y, busConnector.HeatInsensibleLung_H2O) annotation (Line(
     points={{-83.7,65},{90,65},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(HeatInsensibleSkin_H2O.y, busConnector.HeatInsensibleSkin_H2O) annotation (Line(
     points={{-83.7,75},{90,75},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(ICFV_Vol.y, busConnector.ICFV_Vol) annotation (Line(
     points={{-83.7,85},{90,85},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(kidney_InterstitialWater.y, busConnector.kidney_InterstitialWater) annotation (Line(
     points={{-83.7,95},{90,95},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Kidney_LiquidVol.y, busConnector.Kidney_LiquidVol) annotation (Line(
     points={{-83.7,105},{90,105},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(LH_H2O_Outflow.y, busConnector.LH_H2O_Outflow) annotation (Line(
     points={{-83.7,115},{90,115},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(leftHeart_InterstitialWater.y, busConnector.leftHeart_InterstitialWater) annotation (Line(
     points={{94.3,-145},{90,-145},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(LeftHeart_LiquidVol.y, busConnector.LeftHeart_LiquidVol) annotation (Line(
     points={{94.3,-135},{90,-135},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(liver_InterstitialWater.y, busConnector.liver_InterstitialWater) annotation (Line(
     points={{94.3,-125},{90,-125},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Liver_LiquidVol.y, busConnector.Liver_LiquidVol) annotation (Line(
     points={{94.3,-115},{90,-115},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Medulla_Volume.y, busConnector.Medulla_Volume) annotation (Line(
     points={{94.3,-85},{90,-85},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Osmreceptors.y, busConnector.Osmreceptors) annotation (Line(
     points={{94.3,-75},{90,-75},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(otherTissue_InterstitialWater.y, busConnector.otherTissue_InterstitialWater) annotation (Line(
     points={{94.3,-65},{90,-65},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(OtherTissue_LiquidVol.y, busConnector.OtherTissue_LiquidVol) annotation (Line(
     points={{94.3,-55},{90,-55},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(PeritoneumSpace_Vol.y, busConnector.PeritoneumSpace_Vol) annotation (Line(
     points={{94.3,-25},{90,-25},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(PlasmaVol.y, busConnector.PlasmaVol) annotation (Line(
     points={{94.3,-15},{90,-15},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(PlasmaVol_Vol.y, busConnector.PlasmaVol_Vol) annotation (Line(
     points={{94.3,-5},{90,-5},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(respiratoryMuscle_InterstitialWater.y, busConnector.respiratoryMuscle_InterstitialWater) annotation (Line(
     points={{94.3,5},{90,5},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(RespiratoryMuscle_LiquidVol.y, busConnector.RespiratoryMuscle_LiquidVol) annotation (Line(
     points={{94.3,15},{90,15},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(rightHeart_InterstitialWater.y, busConnector.rightHeart_InterstitialWater) annotation (Line(
     points={{94.3,25},{90,25},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(RightHeart_LiquidVol.y, busConnector.RightHeart_LiquidVol) annotation (Line(
     points={{94.3,35},{90,35},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(skeletalMuscle_InterstitialWater.y, busConnector.skeletalMuscle_InterstitialWater) annotation (Line(
     points={{94.3,45},{90,45},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(SkeletalMuscle_LiquidVol.y, busConnector.SkeletalMuscle_LiquidVol) annotation (Line(
     points={{94.3,55},{90,55},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(skin_InterstitialWater.y, busConnector.skin_InterstitialWater) annotation (Line(
     points={{94.3,65},{90,65},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(Skin_LiquidVol.y, busConnector.Skin_LiquidVol) annotation (Line(
     points={{94.3,75},{90,75},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(BladderVoidFlow.y,busConnector.BladderVoidFlow) annotation (Line(
          points={{-157.7,-135},{90,-135},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(SweatGland_H2ORate.y, busConnector.SweatGland_H2ORate)
        annotation (Line(
          points={{-83.7,153},{90,153},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(Liver_CellH2O.y, busConnector.liver_CellH2OVol) annotation (Line(
          points={{-217.7,3},{-151.85,3},{-151.85,-2},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(SkeletalMuscle_CellH2O.y, busConnector.skeletalMuscle_CellH2OVol)
        annotation (Line(
          points={{-219.7,23},{-150.85,23},{-150.85,-2},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(RespiratoryMuscle_CellH2O.y, busConnector.respiratoryMuscle_CellH2OVol)
        annotation (Line(
          points={{-207.7,13},{-145.85,13},{-145.85,-2},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(PeritoneumSpace_Change.y, busConnector.PeritoneumSpace_Change)
      annotation (Line(
        points={{94.3,-35},{98,-35},{98,-38},{90,-38},{90,-2}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(Vasopressin.y, busConnector.Vasopressin) annotation (Line(
        points={{-97.7,-147},{90,-147},{90,-2}},
        color={0,0,127},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(LT_InterstitialWater_Vol.y, busConnector.LT.InterstitialWater_Vol) annotation (Line(
     points={{-83.7,125},{90,125},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(UT_LymphFlow.y, busConnector.UT.LymphFlow) annotation (Line(
     points={{94.3,105},{90,105},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(UT_InterstitialWater_Vol.y, busConnector.UT.InterstitialWater_Vol) annotation (Line(
     points={{94.3,95},{90,95},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(MT_LymphFlow.y, busConnector.MT.LymphFlow) annotation (Line(
     points={{94.3,-95},{90,-95},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
    connect(MT_InterstitialWater_Vol.y, busConnector.MT.InterstitialWater_Vol) annotation (Line(
     points={{94.3,-105},{90,-105},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      connect(LT_LymphFlow.y, busConnector.LT.LymphFlow) annotation (Line(
          points={{-83.7,135},{90,135},{90,-2}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                -100},{100,100}}), graphics={Text(
              extent={{18,118},{100,80}},
              lineColor={0,0,0},
              textString="vars"), Text(
              extent={{-120,-100},{122,-134}},
              lineColor={0,0,255},
              textString="%name")}), Diagram(coordinateSystem(
              preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
            graphics));
    end Variables;

    model Water_test
      import Physiomodel;

    Physiomodel.CardioVascular.IO_Bus.InputFromFile cardioVascularSystem
        annotation (Placement(transformation(extent={{40,72},{60,94}})));
      Physiomodel.Metabolism.IO_Bus.InputFromFile nutrientsAndMetabolism
        annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
      Physiomodel.Electrolytes.IO_Bus.InputFromFile electrolytes
        annotation (Placement(transformation(extent={{74,-34},{94,-14}})));
      Physiomodel.Hormones.IO_Bus.InputFromFile hormones
        annotation (Placement(transformation(extent={{40,6},{60,26}})));
      Physiomodel.Nerves.IO_Bus.InputFromFile nerves
        annotation (Placement(transformation(extent={{74,38},{94,58}})));
      Physiomodel.Setup.IO_Bus.InputFromFile     setup
        annotation (Placement(transformation(extent={{-16,-106},{4,-86}})));
    Physiomodel.Water.Water water
      annotation (Placement(transformation(extent={{-86,-6},{-66,14}})));
      Physiomodel.Proteins.IO_Bus.InputFromFile proteins
        annotation (Placement(transformation(extent={{-48,-28},{-28,-8}})));
      Physiomodel.Status.IO_Bus.InputFromFile status
        annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
      Physiomodel.Gases.IO_Bus.InputFromFile gases
        annotation (Placement(transformation(extent={{-76,-64},{-56,-44}})));
      Physiomodel.Heat.IO_Bus.InputFromFile heat
        annotation (Placement(transformation(extent={{-30,36},{-50,56}})));
      Physiomodel.Water.IO_Bus.OutputComparison water_dif
        annotation (Placement(transformation(extent={{-102,-8},{-82,12}})));
      Physiomodel.Water.IO_Bus.OutputToFile water_varsToFile
        annotation (Placement(transformation(extent={{-62,2},{-42,22}})));
    equation
      connect(setup.busConnector,hormones. busConnector) annotation (Line(
          points={{-6,-96},{-6,16},{50,16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,proteins. busConnector) annotation (Line(
          points={{-6,-96},{-6,-18},{-38,-18}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,cardioVascularSystem. busConnector)
                                                    annotation (Line(
          points={{-6,-96},{-6,83},{50,83}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,nutrientsAndMetabolism. busConnector)
        annotation (Line(
          points={{-6,-96},{-6,70},{-78,70}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,water. busConnector) annotation (Line(
          points={{-6,-96},{-6,11},{-69,11}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,nerves. busConnector) annotation (Line(
          points={{-6,-96},{-6,48},{84,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(status.busConnector,setup. busConnector)         annotation (Line(
          points={{52,-70},{-6,-70},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(electrolytes.busConnector,setup. busConnector) annotation (Line(
          points={{84,-24},{-6,-24},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gases.busConnector,setup. busConnector) annotation (Line(
          points={{-66,-54},{-6,-54},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(heat.busConnector,setup. busConnector) annotation (Line(
          points={{-40,46},{-6,46},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(water.busConnector, water_dif.busConnector) annotation (Line(
          points={{-69,11},{-81.5,11},{-81.5,2},{-92,2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(water.busConnector, water_varsToFile.busConnector) annotation (
          Line(
          points={{-69,11},{-59.5,11},{-59.5,12},{-52,12}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
              {{-100,-100},{100,100}}),
                          graphics));
    end Water_test;

    model Water_test_SI
      import Physiomodel;

    Physiomodel.CardioVascular.IO_Bus.InputFromFile_SI cardioVascularSystem
        annotation (Placement(transformation(extent={{40,72},{60,94}})));
      Physiomodel.Metabolism.IO_Bus.InputFromFile_SI nutrientsAndMetabolism
        annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
      Physiomodel.Electrolytes.IO_Bus.InputFromFile_SI electrolytes
        annotation (Placement(transformation(extent={{74,-34},{94,-14}})));
      Physiomodel.Hormones.IO_Bus.InputFromFile_SI hormones
        annotation (Placement(transformation(extent={{40,6},{60,26}})));
      Physiomodel.Nerves.IO_Bus.InputFromFile_SI nerves
        annotation (Placement(transformation(extent={{74,38},{94,58}})));
      Physiomodel.Setup.IO_Bus.InputFromFile_SI     setup
        annotation (Placement(transformation(extent={{-16,-106},{4,-86}})));
    Physiomodel.Water.Water water
      annotation (Placement(transformation(extent={{-98,-8},{-78,12}})));
      Physiomodel.Proteins.IO_Bus.InputFromFile_SI proteins
        annotation (Placement(transformation(extent={{-48,-28},{-28,-8}})));
      Physiomodel.Status.IO_Bus.InputFromFile_SI status
        annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
      Physiomodel.Gases.IO_Bus.InputFromFile_SI gases
        annotation (Placement(transformation(extent={{-76,-64},{-56,-44}})));
      Physiomodel.Heat.IO_Bus.InputFromFile_SI heat
        annotation (Placement(transformation(extent={{-30,36},{-50,56}})));
      Physiomodel.Water.IO_Bus.OutputComparison_SI water_dif
        annotation (Placement(transformation(extent={{-42,2},{-22,22}})));
      Physiomodel.Water.IO_Bus.OutputToFile_SI water_varsToFile
        annotation (Placement(transformation(extent={{-62,2},{-42,22}})));
    equation
      connect(setup.busConnector,hormones. busConnector) annotation (Line(
          points={{-6,-96},{-6,16},{50,16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,proteins. busConnector) annotation (Line(
          points={{-6,-96},{-6,-18},{-38,-18}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,cardioVascularSystem. busConnector)
                                                    annotation (Line(
          points={{-6,-96},{-6,83},{50,83}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,nutrientsAndMetabolism. busConnector)
        annotation (Line(
          points={{-6,-96},{-6,70},{-78,70}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,water. busConnector) annotation (Line(
          points={{-6,-96},{-6,9},{-81,9}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(setup.busConnector,nerves. busConnector) annotation (Line(
          points={{-6,-96},{-6,48},{84,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(status.busConnector,setup. busConnector)         annotation (Line(
          points={{52,-70},{-6,-70},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(electrolytes.busConnector,setup. busConnector) annotation (Line(
          points={{84,-24},{-6,-24},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gases.busConnector,setup. busConnector) annotation (Line(
          points={{-66,-54},{-6,-54},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(heat.busConnector,setup. busConnector) annotation (Line(
          points={{-40,46},{-6,46},{-6,-96}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(water.busConnector, water_dif.busConnector) annotation (Line(
          points={{-81,9},{-81.5,9},{-81.5,12},{-32,12}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      connect(water.busConnector, water_varsToFile.busConnector) annotation (
          Line(
          points={{-81,9},{-59.5,9},{-59.5,12},{-52,12}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
              {{-100,-100},{100,100}}),
                          graphics),
      experiment(StopTime=864000),
      __Dymola_experimentSetupOutput);
    end Water_test_SI;
  end IO_Bus;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),                   Documentation(revisions="<html>

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
<td><p>2009-2014</p></td>
</tr>
<tr>
<td><p>References:</p></td>
<td><p>Tom Coleman: QHP 2008 beta 3, University of Mississippi Medical Center</p></td>
</tr>
</table>
<br/><p>Copyright &copy; 2014 Marek Matejak</p><br/>

</html>",
        info="<html>
<p>Sources of water in human body are from diet and base mitochondrial metabolism, where from each consumed oxygen molecule is creader two water molecules by adding hydrogen ions with electrons.</p>
<p>The amount of plasma volume is regulated by kidney excretion to urine. This process is regulated through hormone Vasopressin(ADH) [Atherton1971,Khokhar1976] with efect on aquapirins - membrane chanels of nephrons in kidney [Gottschalk1959,Nielsen2000].</p>
<p>The right amount of water in each compartment determines the osmolarities and all concentrations inside compartment. Water can cross the capillary wall to reach the same ospomarity of interstitium and plasma [Landis1933,Xie1995]. From interstitium is transported back to plasma together with proteins by lymphatic system [Guyton1965, Engeset1973,Olszewiski1980,Henriksen1985,Auckland1993].</p>
<p>Water is also necessary for termoregulation in heat conditions, where evaporation takes heat from body to cool it down. Evaporation can be driven by sweating [Dodt1952,Wyndham1966,Piwonka1967,Benzinger1969,Sato1977,Sato1989a,b] or be spontaneus from lungs [Brebbia1957] and insensible tissues.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics));
end Water2;
