within Physiomodel;
package Interfaces
  partial connector SignalBusBlue "Icon for signal bus"

    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.2), graphics={
          Rectangle(
            extent={{-20,2},{20,-2}},
            lineColor={255,204,51},
            lineThickness=0.5),
          Polygon(
            points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,-50},{
                -80,-40},{-100,30},{-80,50}},
            lineColor={0,0,0},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-65,25},{-55,15}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-5,25},{5,15}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{55,25},{65,15}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-35,-15},{-25,-25}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{25,-15},{35,-25}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.2), graphics={
          Polygon(
            points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},{-40,
                -20},{-50,15},{-40,25}},
            lineColor={0,0,0},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-32.5,7.5},{-27.5,12.5}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-2.5,12.5},{2.5,7.5}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{27.5,12.5},{32.5,7.5}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-17.5,-7.5},{-12.5,-12.5}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{12.5,-7.5},{17.5,-12.5}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-150,70},{150,40}},
            lineColor={0,0,0},
            textString="%name")}),
      Documentation(info="<html>
<p>
This icon is designed for a <b>signal bus</b> connector.
</p>
</html>"));

  end SignalBusBlue;

  expandable connector BusConnectorInternal
    "Main bus connector that connect all submodels with this huge set of variables"
    extends Physiomodel.Interfaces.SignalBusBlue;
   Real A2Pool_Log10Con(unit="1", nominal=1.29897876942049)
      "Decimal logarithm of angiotensin 2 extracelular concentration. Original name: A2Pool.Log10Conc";
   Real A2Pool_Log10Conc(unit="1", nominal=1.29897876942049)
      "Decimal logarithm of angiotensin 2 extracelular concentration. Original name: A2Pool.Log10Conc";
   Real ADHPool_Log10Conc(unit="1", nominal=0.2990222010403)
      "Decimal logarithm of vasopressin concentration. Original name: ADHPool.Log10Conc";
   Real ADH(unit="ng/l", nominal=1.99077510438026)
      "Vasopressin extracellular concentration. Original name: ADHPool.[ADH]";
   Real ANPPool_Log10Conc(unit="1", nominal=1.2990222010403)
      "Decimal logarithm of atrial natriuretic peptide concentration. Original name: ANPPool.Log10Conc";
   Real AdrenalNerve_NA(unit="1", nominal=1.00590910582759)
      "Nerve activity of adrenal nerve. Original name: AdrenalNerve.NA";
   Real AirSupplyInspiredAirPressure(unit="mmHg", nominal=760.)
      "Air pressure. Original name: AirSupply-InspiredAir.Pressure";
   Real Aldo_conc_in_nG_per_dl(unit="ng/dl", nominal=11.88)
      "Body aldosterone concentration. Original name: AldoPool.[Aldo(nG/dL)]";
   Real AldoPool_Aldo(unit="pmol/l", nominal=330.)
      "Body aldosterone concentration. Original name: AldoPool.[Aldo(pMol/L)]";
   Real AlphaBlocade_Effect(unit="1", nominal=1.)
      "Effect of alpha blocators. Original name: AlphaBlockade.Effect";
   Real AlphaPool_Effect(unit="1", nominal=0.99972591818532)
      "Humoral and neural effect on alpha receptor stimulation. Original name: AlphaPool.Effect";
   Real AnesthesiaTidalVolume(unit="ml", nominal=1.)
      "Anesthesia gas tidal volume. Original name: Anesthesia.TidalVolume";
   Real Anesthesia_VascularConductance(unit="1", nominal=1.)
      "Anesthesia tension effect on vascular conductance in some tissues. Original name: Anesthesia.VascularConductance";
   Real ArtysVol(unit="ml", nominal=1598.5)
      "Volume of oxygenated blood in body. Original name: ArtysVol.Vol";
   Real BarometerPressure(unit="mmHg", nominal=760.)
      "Ambient environment pressure. Original name: Barometer.Pressure";
   Real BetaBlocade_Effect(unit="1", nominal=1.)
      "Effect of beta blocators. Original name: BetaBlockade.Effect";
   Real BetaPool_Effect(unit="1", nominal=0.99972591818532)
      "Humoral and neural effect on beta receptor stimulation. Original name: BetaPool.Effect";
   Real BladderVoidFlow(unit="ml/min", nominal=1.7)
      "Urination flow. Original name: BladderVoidFlow";
   Real BladderVolume_Mass(unit="ml", nominal=200.)
      "Urine volume in bladder. Original name: BladderVolume.Mass";
   Real BloodCations(unit="mEq/l", nominal=147.735807515379)
      "Sum of all cations concentrations in blood. Original name: BloodIons.Cations";
   Real BloodIons_Cations(unit="mEq/l", nominal=147.735807515379)
      "Sum of all cations concentrations in blood. Original name: BloodIons.Cations";
   Real BloodIons_ProteinAnions(unit="mEq/l", nominal=15.0835337930175)
      "concentration of nonbicarbonate buffers in anion forms. Original name: BloodIons.Protein";
   Real Artys_pH(unit="1", nominal=7.4)
      "Acidity (pH) of arterial blood. Original name: BloodPh.ArtysPh";
   Real BloodPh_ArtysPh(unit="1", nominal=7.4)
      "Acidity (pH) of arterial blood. Original name: BloodPh.ArtysPh";
   Real BloodVol_Hct(unit="1", nominal=0.44)
      "Heamatocrit = red cells / blood. Original name: BloodVol.Hct";
   Real BloodVol_PVCrit(unit="1", nominal=0.56)
      "Plasma volume fraction = plasma / blood. Original name: BloodVol.PVCrit";
   Real BodyH2O_Vol(unit="ml", nominal=40842.2008941024)
      "Body water volume. Original name: BodyH2O.Vol";
   Real bone_CO2FromMetabolism(unit="ml/min", nominal=0.510087812548753)
      "Bone carbondioxyde outflow from cells metabolism. Original name: Bone-CO2.OutflowBase";
   Real Bone_BloodFlow(unit="ml/min", nominal=324.086048840702)
      "Bone blood flow. Original name: Bone-Flow.BloodFlow";
   Real bone_BloodFlow(unit="ml/min", nominal=324.086048840702)
      "Bone blood flow. Original name: Bone-Flow.BloodFlow";
   Real bone_O2Use(unit="ml/min", nominal=14.2961830871287)
      "Bone oxygen consumption. Original name: Bone-Flow.O2Use";
   Real Bone_PO2(unit="mmHg", nominal=42.2937436361259)
      "Partial oxygen pressure in bone blood venules. Original name: Bone-Flow.PO2";
   Real bone_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Bone deficiency of nutrients needed by cells metabolism. Original name: Bone-Fuel.FractUseDelay";
   Real bone_LactateFromMetabolism(unit="mEq/min", nominal=5.09422470717388e-005)
      "Lactate flow from bone cells. Original name: Bone-Lactate.Outflux";
   Real bone_cLactate(unit="meq/l", nominal=1.28169548960037)
      "Bone intracellular lactate concentration. Original name: Bone-Lactate.[Lac-(mEq/L)]";
   Real bone_pH_intracellular(unit="1", nominal=7.03009381463384)
      "Acidity (pH) in bone cells. Original name: Bone-Ph.Ph";
   Real bone_InterstitialWater(unit="ml", nominal=856.611751624329)
      "Bone interstitial water volume. Original name: Bone-Size.IFV";
   Real Bone_LiquidVol(unit="ml", nominal=2738.56)
      "Bone water volume = sum of bone interstitial and bone intracellular water. Original name: Bone-Size.LiquidVol";
   Real Bone_StructureEffect(unit="1", nominal=1.)
      "Bone tissue structural damage effect. Original name: Bone-Structure.Effect";
   Real brain_CO2FromMetabolism(unit="ml/min", nominal=1.40245737390225)
      "Brain carbondioxyde outflow from cells metabolism. Original name: Brain-CO2.OutflowBase";
   Real Brain_PCO2(unit="mmHg", nominal=46.5805596402771)
      "Partial carbondioxyde pressure in brain venules. Original name: Brain-CO2.PCO2";
   Real Brain_BloodFlow(unit="ml/min", nominal=817.030903292828)
      "Brain blood flow. Original name: Brain-Flow.BloodFlow";
   Real brain_BloodFlow(unit="ml/min", nominal=817.030903292828)
      "Brain blood flow. Original name: Brain-Flow.BloodFlow";
   Real brain_O2Use(unit="ml/min", nominal=39.3065407483815)
      "Brain oxygen consumption. Original name: Brain-Flow.O2Use";
   Real Brain_PO2(unit="mmHg", nominal=40.3699717617139)
      "Partial oxygen pressure in brain blood venules. Original name: Brain-Flow.PO2";
   Real BrainFuel_FractUseDelay(unit="1", nominal=1.)
      "Brain deficiency of nutrients needed by cells metabolism. Original name: Brain-Fuel.FractUseDelay";
   Real brain_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Brain deficiency of nutrients needed by cells metabolism. Original name: Brain-Fuel.FractUseDelay";
   Real brain_FunctionEffect(unit="1", nominal=1.)
      "Brain tissue function effect. Original name: Brain-Function.Effect";
   Real brain_LactateFromMetabolism(unit="mEq/min", nominal=0.)
      "Lactate flow from brain cells. Original name: Brain-Lactate.Outflux";
   Real brain_cLactate(unit="meq/l", nominal=1.05762236174812)
      "Brain intracellular lactate concentration. Original name: Brain-Lactate.[Lac-(mEq/L)]";
   Real brain_pH_intracellular(unit="1", nominal=7.13738448029574)
      "Acidity (pH) in brain cells. Original name: Brain-Ph.Ph";
   Real brain_InterstitialWater(unit="ml", nominal=242.518568049041)
      "Brain interstitial water volume. Original name: Brain-Size.IFV";
   Real Brain_LiquidVol(unit="ml", nominal=775.324)
      "Brain water volume = sum of brain interstitial and brain intracellular water. Original name: Brain-Size.LiquidVol";
   Real Brain_StructureEffect(unit="1", nominal=1.)
      "Brain tissue structural damage effect. Original name: Brain-Structure.Effect";
   Real BreathingTotalVentilation(unit="ml/min", nominal=6152.76967874893)
      "Gas exchange rate through perfused alveoli. Original name: Breathing.TotalVentilation";
   Real CD_Glucose_Outflow(unit="mg/min", nominal=0.)
      "Collecting duct glucose outflow to urine. Original name: CD_Glucose.Outflow";
   Real CD_H2O_Outflow(unit="ml/min", nominal=0.778920248478402)
      "Collecting duct water outflow to urine. Original name: CD_H2O.Outflow";
   Real CD_H2O_Reab(unit="ml/min", nominal=3.77977991766273)
      "Collecting duct water reabsorbtion. Original name: CD_H2O.Reab";
   Real CD_K_Outflow(unit="mEq/min", nominal=5.37344289504483e-002)
      "Collecting duct potassium outflow to urine. Original name: CD_K.Outflow";
   Real CD_KA_Outflow(unit="mg/min", nominal=0.)
      "Collecting duct keto-acids outflow to urine. Original name: CD_KA.Outflow";
   Real CD_NH4_Outflow(unit="mEq/min", nominal=2.81943560926806e-002)
      "Collecting duct amonia ions outflow to urine. Original name: CD_NH4.Outflow";
   Real CD_Na_Outflow(unit="mEq/min", nominal=0.125408921478924)
      "Collecting duct sodium outflow to urine. Original name: CD_Na.Outflow";
   Real CD_PO4_Outflow(unit="mEq/min", nominal=2.30917372066747e-002)
      "Collecting duct phosphates outflow to urine. Original name: CD_PO4.Outflow";
   Real CO2Veins_cHCO3(unit="meq/l", nominal=25.6)
      "Bicarbonate concentration in mixed venous blood. Original name: CO2Veins.[HCO3(mEq/L)]";
   Real CardiacOutput(unit="ml/min", nominal=5504.05387990819)
      "Cardiac output. Original name: CardiacOutput.Flow";
   Real CarotidSinusHeight(unit="m", nominal=0.)
      "Height of carotid sinus above heart level. Original name: CarotidSinus.Level";
   Real CarotidSinusArteryPressure(unit="mmHg", nominal=96.1290322580645)
      "Mean blood pressure in carotid sinus artery. Original name: CarotidSinus.Pressure";
   Real CellH2O_Vol(unit="ml", nominal=24914.8813825901)
      "Intracellular water volume. Original name: CellH2O.Vol";
   Real CellProtein_Mass(unit="mg", nominal=6000000.)
      "Weight of all cellular proteins. Original name: CellProtein.Mass";
   Real DT_AldosteroneEffect(unit="1", nominal=1)
      "Aldosterone effect to distal tubule reabsorbtion. Original name: DT_AldosteroneEffect";
   Real DT_Na_Outflow(unit="mEq/min", nominal=0.501457018275525)
      "Distal tubule sodium outflow. Original name: DT_Na.Outflow";
   Real DT_Na_Reab(unit="mEq/min", nominal=1.37104712291894)
      "Distal tubule sodium reabsorbtion. Original name: DT_Na.Reab";
   Real DialyzerActivity_Cl_Flux(unit="mEq/min", nominal=0.)
      "Outflow of chloride ions through dialyzer. Original name: DialyzerActivity.Cl-Flux";
   Real DialyzerActivity_K_Flux(unit="mEq/min", nominal=0.)
      "Outflow of potassium ions through dialyzer. Original name: DialyzerActivity.K+Flux";
   Real DialyzerActivity_Na_Flux(unit="mEq/min", nominal=0.)
      "Outflow of sodium ions through dialyzer. Original name: DialyzerActivity.Na+Flux";
   Real DietGoalH2O_DegK(unit="K", nominal=294.261111111111)
      "Temperature of water in diet (consumed oraly). Original name: DietGoalH2O.DegK";
   Real DietIntakeElectrolytes_Cl(unit="mEq/min", nominal=0.13910967422831)
      "Intake of chlorides through GIT. Original name: DietIntakeElectrolytes.Cl-_mEq/Min";
   Real DietIntakeElectrolytes_K(unit="mEq/min", nominal=4.86883859799086e-002)
      "Intake of potassium through GIT. Original name: DietIntakeElectrolytes.K+_mEq/Min";
   Real DietIntakeElectrolytes_Na(unit="mEq/min", nominal=0.125198706805479)
      "Intake of sodium through GIT. Original name: DietIntakeElectrolytes.Na+_mEq/Min";
   Real DietIntakeElectrolytes_PO4(unit="mEq/min", nominal=2.08664511342466e-002)
      "Intake of phosphates through GIT. Original name: DietIntakeElectrolytes.PO4--mEq/Min";
   Real DietIntakeElectrolytes_SO4(unit="mEq/min", nominal=3.47774185570776e-002)
      "Intake of sulphates through GIT. Original name: DietIntakeElectrolytes.SO4--mEq/Min";
   Real ECFV_Vol(unit="ml", nominal=14361.0097207699)
      "Extracellular fluid volume. Original name: ECFV.Vol";
   Real EPOPool_Log10Conc(unit="1", nominal=1.2990222010403)
      "Dacimal logarithm of erythropoetin concentration. Original name: EPOPool.Log10Conc";
   Real EpiPool_Epi(unit="pg/ml", nominal=39.8155020876053)
      "Epinephrine extracelular concentration. Original name: EpiPool.[Epi(pG/mL)]";
   Real ExcessLungWater_Volume(unit="ml", nominal=0.)
      "Pulmonary edema water. Original name: ExcessLungWater.Volume";
   Real Exercise_Metabolism_ContractionRate(unit="1/min", nominal=0.)
      "Rate of muscle contraction through excercise. Original name: Exercise-Metabolism.ContractionRate";
   Real ExerciseMetabolism_MotionCals(unit="Cal", nominal=0.)
      "Calories consumed with exercise. Original name: Exercise-Metabolism.MotionCals";
   Real Exercise_Metabolism_MotionWatts(unit="w", nominal=0.)
      "Mechanical performance of excercise. Original name: Exercise-Metabolism.MotionWatts";
   Real ExerciseMetabolism_TotalWatts(unit="w", nominal=0.)
      "Termodynamical performance of excercise. Original name: Exercise-Metabolism.TotalWatts";
   Real Exercise_MusclePump_Effect(unit="1", nominal=1.)
      "Excercise effect to blood flow through veins with valves. Original name: Exercise-MusclePump.Effect";
   Real FHbF(unit="1", nominal=0.005)
      "Fetal heamoglobin fraction. Original name: FHbF";
   Real FMetHb(unit="1", nominal=0.005)
      "Methemoglobin fraction. Original name: FMetHb";
   Real fat_CO2FromMetabolism(unit="ml/min", nominal=0.219871145602797)
      "Fat carbondioxyde outflow from cells metabolism. Original name: Fat-CO2.OutflowBase";
   Real Fat_BloodFlow(unit="ml/min", nominal=241.149275495811)
      "Fat blood flow. Original name: Fat-Flow.BloodFlow";
   Real fat_BloodFlow(unit="ml/min", nominal=241.149275495811)
      "Fat blood flow. Original name: Fat-Flow.BloodFlow";
   Real fat_O2Use(unit="ml/min", nominal=6.16230789245506)
      "Fat oxygen consumption. Original name: Fat-Flow.O2Use";
   Real Fat_PO2(unit="mmHg", nominal=53.2028712998172)
      "Partial oxygen pressure in fat blood venules. Original name: Fat-Flow.PO2";
   Real fat_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Fat deficiency of nutrients needed by cells metabolism. Original name: Fat-Fuel.FractUseDelay";
   Real FatFunctionEffect(unit="1", nominal=1.00000000000068)
      "Fat tissue function effect. Original name: Fat-Function.Effect";
   Real fat_LactateFromMetabolism(unit="mEq/min", nominal=0.)
      "Lactate flow from fat cells. Original name: Fat-Lactate.Outflux";
   Real fat_cLactate(unit="meq/l", nominal=1.)
      "Fat intracellular lactate concentration. Original name: Fat-Lactate.[Lac-(mEq/L)]";
   Real fat_pH_intracellular(unit="1", nominal=7.30413901261407)
      "Acidity (pH) in fat cells. Original name: Fat-Ph.Ph";
   Real fat_InterstitialWater(unit="ml", nominal=778.863074588316)
      "Fat interstitial water volume. Original name: Fat-Size.IFV";
   Real Fat_LiquidVol(unit="ml", nominal=2490.)
      "Fat water volume = sum of fat interstitial and fat intracellular water. Original name: Fat-Size.LiquidVol";
   Real Fat_StructureEffect(unit="1", nominal=1.)
      "Fat tissue structural damage effect. Original name: Fat-Structure.Effect";
   Real FurosemidePool_Loss(unit="mg/min", nominal=0.)
      "Furosemide outflow from body. Original name: FurosemidePool.Loss";
   Real FurosemidePool_Furosemide_conc(unit="ug/ml", nominal=0.)
      "Furosemide extracellular concentration. Original name: FurosemidePool.[Furosemide]";
   Real GILumenDiarrhea_KLoss(unit="meq/min", nominal=0)
      "Outflow of potassium by diarrhea. Original name: GILumenDiarrhea.K+Loss";
   Real GILumenDiarrhea_NaLoss(unit="meq/min", nominal=0.)
      "Outflow of sodium by diarrhea. Original name: GILumenDiarrhea.Na+Loss";
   Real GILumenPotassium_Mass(unit="mEq", nominal=25.)
      "Potasium mass in intestines. Original name: GILumenPotassium.Mass";
   Real GILumenSodium_Mass(unit="mEq", nominal=80.)
      "Sodium mass in intestines. Original name: GILumenSodium.Mass";
   Real GILumenVolume_Absorption(unit="ml/min", nominal=1.94)
      "Water absorbtion through intestines. Original name: GILumenVolume.Absorption";
   Real GILumenVolume_Intake(unit="ml/min", nominal=1.94)
      "Water intake to intestines. Original name: GILumenVolume.Intake";
   Real GILumenVolume_Mass(unit="ml", nominal=1000.)
      "Water in intestines. Original name: GILumenVolume.Mass";
   Real GILumenVomitus_ClLoss(unit="meq/min", nominal=0.)
      "Chloride outflow by vomitus. Original name: GILumenVomitus.Cl-Loss";
   Real GITract_CO2FromMetabolism(unit="ml/min", nominal=0.671834975908416)
      "GITract carbondioxyde outflow from cells metabolism. Original name: GITract-CO2.OutflowBase";
   Real GITract_BloodFlow(unit="ml/min", nominal=1153.680894008123)
      "GITract blood flow. Original name: GITract-Flow.BloodFlow";
   Real GITract_O2Use(unit="ml/min", nominal=18.8294556028143)
      "GITract oxygen consumption. Original name: GITract-Flow.O2Use";
   Real GITract_PO2(unit="mmHg", nominal=58.8550845443996)
      "Partial oxygen pressure in gITract blood venules. Original name: GITract-Flow.PO2";
   Real GITract_Fuel_FractUseDelay(unit="1", nominal=1.)
      "GITract deficiency of nutrients needed by cells metabolism. Original name: GITract-Fuel.FractUseDelay";
   Real GITractFunctionEffect(unit="1", nominal=1.00000000000068)
      "GITract tissue function effect. Original name: GITract-Function.Effect";
   Real GITract_LactateFromMetabolism(unit="mEq/min", nominal=7.46238924200865e-005)
      "Lactate flow from gITract cells. Original name: GITract-Lactate.Outflux";
   Real GITract_cLactate(unit="meq/l", nominal=1.29112224345401)
      "GITract intracellular lactate concentration. Original name: GITract-Lactate.[Lac-(mEq/L)]";
   Real GITract_pH_intracellular(unit="1", nominal=7.02397749899767)
      "Acidity (pH) in gITract cells. Original name: GITract-Ph.Ph";
   Real GITract_InterstitialWater(unit="ml", nominal=266.493787704079)
      "GITract interstitial water volume. Original name: GITract-Size.IFV";
   Real GITract_LiquidVol(unit="ml", nominal=851.972)
      "GITract water volume = sum of gITract interstitial and gITract intracellular water. Original name: GITract-Size.LiquidVol";
   Real GITract_StructureEffect(unit="1", nominal=1.)
      "GITract tissue structural damage effect. Original name: GITract-Structure.Effect";
   Real GangliaGeneral_NA(unit="hz", nominal=1.50810960393941)
      "Neural activity of autonomous sympathetic nervous system. Original name: GangliaGeneral.NA(Hz)";
   Real GangliaKidney_NA(unit="hz", nominal=1.49161825060908)
      "Sympathetis kidney ganglia neural activity. Original name: GangliaKidney.NA(Hz)";
   Real GlomerulusFiltrate_GFR(unit="ml/min", nominal=129.49686727571)
      "Glomerulus filtration rate. Original name: GlomerulusFiltrate.GFR";
   Real Glomerulus_GFR(unit="ml/min", nominal=129.49686727571)
      "Glomerulus filtration rate. Original name: GlomerulusFiltrate.GFR";
   Real GlomerulusBloodPressure(unit="mmHg", nominal=60.7727410497984)
      "Blood pressure in glomerulus capilaries. Original name: GlomerulusFiltrate.Pressure";
   Real Glucagon_conc(unit="ng/l", nominal=69.6771286533093)
      "Extracellular glucagon concentration. Original name: GlucagonPool.[Glucagon]";
   Real GlucoseECF_Osmoles(unit="mOsm/ml", nominal=87.3569296901635)
      "Extracellular glucose osmolarity. Original name: GlucosePool.Osmoles";
   Real Glucose(unit="mg/dl", nominal=109.492630740915)
      "Extracellular glucose concentration. Original name: GlucosePool.[Glucose(mG/dL)]";
   Real G(unit="1", nominal=1.)
      "Earth gravity fraction. Original name: Gravity.Gz";
   Real Gravity_Gz(unit="1", nominal=1.)
      "Earth gravity fraction. Original name: Gravity.Gz";
   Real HeartVentricleRate(unit="1/min", nominal=72.1519231143317)
      "Heart rate. Original name: Heart-Ventricles.Rate";
   Real GITract_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real HeatCore_Temp(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real bone_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real brain_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real core_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real fat_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real kidney_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real liver_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real otherTissue_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real respiratoryMuscle_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real rightHeart_T(unit="degC", nominal=37)
      "Body core temperature. Original name: HeatCore.Temp(C)";
   Real HeatInsensibleLung_H2O(unit="g/min", nominal=0.265354795938769)
      "Vaporized water outflow by breathing. Original name: HeatInsensibleLung.H2O";
   Real HeatInsensibleSkin_H2O(unit="g/min", nominal=0.37)
      "Vaporized water outflow from skin. Original name: HeatInsensibleSkin.H2O";
   Real skeletalMuscle_T(unit="c", nominal=37.0555555555556)
      "Skeletal muscle temperature. Original name: HeatSkeletalMuscle.Temp(C)";
   Real skin_T(unit="c", nominal=28.8888888888889)
      "Skin temperature. Original name: HeatSkin.Temp(C)";
   Real Hemorrhage_ClRate(unit="mEq/min", nominal=0.)
      "Chloride outflow by hemorrhage. Original name: Hemorrhage.ClRate";
   Real Hemorrhage_KRate(unit="mEq/min", nominal=0.)
      "Potassium outflow by hemorrhage. Original name: Hemorrhage.KRate";
   Real Hemorrhage_NaRate(unit="mEq/min", nominal=0.)
      "Sodium outflow by hemorrhage. Original name: Hemorrhage.NaRate";
   Real Hemorrhage_PlasmaRate(unit="ml/min", nominal=0.)
      "Plasma outflow by hemorrhage. Original name: Hemorrhage.PlasmaRate";
   Real Hemorrhage_ProteinRate(unit="mg/min", nominal=0.)
      "Protein outflow by hemorrhage. Original name: Hemorrhage.ProteinRate";
   Real Hemorrhage_RBCRate(unit="ml/min", nominal=0.)
      "Erythrocytes outflow by hemorrhage. Original name: Hemorrhage.RBCRate";
   Real HepaticArty_BloodFlow(unit="ml/min", nominal=246.447690322581)
      "Hepatic artery blood flow. Original name: HepaticArty.Flow";
   Real LowerTorsoArtyHeight(unit="mmHg", nominal=0.)
      "Mean height of lower torso arteries below heart. Original name: Hydrostatics.LowerTorsoArtyGradient";
   Real LowerTorsoVeinHeight(unit="mmHg", nominal=0.)
      "Mean height of lower torso veins below heart. Original name: Hydrostatics.LowerTorsoVeinGradient";
   Real HypothalamusShivering_NerveActivity(unit="1", nominal=0.)
      "Hypothalamus shivering nerve activity. Original name: HypothalamusShivering.NerveActivity";
   Real HypothalamusSkinFlow_NervesActivity(unit="1", nominal=1.0000000000001)
      "Hypothalamus nerve activity affecting skin blood flow. Original name: HypothalamusSkinFlow.NerveActivity";
   Real ICFV_Vol(unit="ml", nominal=26481.1911733325)
      "Intracellular water volume. Original name: ICFV.Vol";
   Real IVDrip_ClRate(unit="mEq/min", nominal=0.)
      "Intravenous chloride intake. Original name: IVDrip.ClRate";
   Real IVDrip_H2ORate(unit="ml/min", nominal=0.)
      "Intravenous water intake. Original name: IVDrip.H2ORate";
   Real IVDrip_KRate(unit="mEq/min", nominal=0.)
      "Intravenous potassium intake. Original name: IVDrip.KRate";
   Real IVDrip_NaRate(unit="mEq/min", nominal=0.)
      "Intravenous sodium intake. Original name: IVDrip.NaRate";
   Real Insulin(unit="uU/ml", nominal=19.9077510438027)
      "Insulin extracellular concentration. Original name: InsulinPool.[Insulin]";
   Real KA_Change(unit="mg/min", nominal=1.68416089014077)
      "Change of keto-acids extracellular mass. Original name: KAPool.Change";
   Real KAPool_Osmoles(unit="mOsm/ml", nominal=0.700443745333856)
      "Keto-acids extracellular osmolarity. Original name: KAPool.Osmoles";
   Real PotassiumToCells(unit="1", nominal=0)
      "PotasiumToCells Original name: KCell.Change";
   Real KCell_conc(unit="meq/l", nominal=151.304559096149)
      "Intracellular potassium concentration. Original name: KCell.[K+(mEq/L)]";
   Real KPool_per_liter(unit="meq/l", nominal=4.4)
      "Potassium extracellular concentration. Original name: KPool.[K+(mEq/L)]";
   Real Kidney_Alpha_NA(unit="1", nominal=1.)
      "Kidney alpha neural activity effect. Original name: Kidney-Alpha.NA";
   Real KidneyAlpha_PT_NA(unit="1", nominal=1.)
      "Kidney alpha proximal tubule neural activity effect. Original name: Kidney-Alpha.PT_NA";
   Real kidney_CO2FromMetabolism(unit="ml/min", nominal=0.725345054073534)
      "Kidney carbondioxyde outflow from cells metabolism. Original name: Kidney-CO2.OutflowBase";
   Real Kidney_BloodFlow(unit="ml/min", nominal=1242.65169526077)
      "Kidney blood flow. Original name: Kidney-Flow.BloodFlow";
   Real kidney_BloodFlow(unit="ml/min", nominal=1242.65169526077)
      "Kidney blood flow. Original name: Kidney-Flow.BloodFlow";
   Real KidneyPlasmaFlow(unit="ml/min", nominal=695.884949346032)
      "Kidney plasma flow. Original name: Kidney-Flow.PlasmaFlow";
   Real kidney_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Kidney deficiency of nutrients needed by cells metabolism. Original name: Kidney-Fuel.FractUseDelay";
   Real KidneyFunctionEffect(unit="1", nominal=1.00000000000068)
      "Kidney tissue function effect. Original name: Kidney-Function.Effect";
   Real KidneyFunction_Effect(unit="1", nominal=1.00000000000068)
      "Kidney tissue function effect. Original name: Kidney-Function.Effect";
   Real kidney_LactateFromMetabolism(unit="mEq/min", nominal=0.)
      "Lactate flow from kidney cells. Original name: Kidney-Lactate.Outflux";
   Real kidney_cLactate(unit="meq/l", nominal=1.05273008000749)
      "Kidney intracellular lactate concentration. Original name: Kidney-Lactate.[Lac-(mEq/L)]";
   Real Kidney_NephronCount_Filtering_xNormal(unit="xnormal", nominal=1.)
      "Fraction of nephron filtering. Original name: Kidney-NephronCount.Filtering(xNormal)";
   Real Kidney_NephronCount_Total_xNormal(unit="xnormal", nominal=1.)
      "Fraction of nephron count. Original name: Kidney-NephronCount.Total(xNormal)";
   Real kidney_O2Use(unit="ml/min", nominal=20.3291775244825)
      "Kidney O2 consumption. Original name: Kidney-O2.O2Use";
   Real KidneyO2_TubulePO2(unit="mmHg", nominal=39.0972281495236)
      "Kidney tubule partial O2 pressure.  Original name: Kidney-O2.TubulePO2";
   Real Kidney_PO2(unit="mmHg", nominal=61.791105140278)
      "Kidney vein partial O2 pressure. Original name: Kidney-O2.VeinPO2";
   Real kidney_pH_intracellular(unit="1", nominal=6.90408555471023)
      "Acidity (pH) in kidney cells. Original name: Kidney-Ph.Ph";
   Real kidney_InterstitialWater(unit="ml", nominal=53.483182307393)
      "Kidney interstitial water volume. Original name: Kidney-Size.IFV";
   Real Kidney_LiquidVol(unit="ml", nominal=170.984)
      "Kidney water volume = sum of kidney interstitial and kidney intracellular water. Original name: Kidney-Size.LiquidVol";
   Real Kidney_StructureEffect(unit="1", nominal=1.)
      "Kidney tissue structural damage effect. Original name: Kidney-Structure.Effect";
   Real LH_H2O_Outflow(unit="ml/min", nominal=39.1458494104607)
      "Water outflow from loop of Henle to distal tubule. Original name: LH_H2O.Outflow";
   Real LH_Na_FractReab(unit="1", nominal=0.744455551715471)
      "Sodium reabsorbtion fraction (=reabsorbed/inflowed) in loop of Henle. Original name: LH_Na.FractReab";
   Real LH_Na_Reab(unit="ml/min", nominal=5.455004453747)
      "Sodium reabsorbtion in loop of Henle. Original name: LH_Na.Reab";
   Real liver_GlucoseToCellStorageFlow(unit="mg/min", nominal=148.405541658881)
      "Liver glycogen gain from glucose. Original name: LM_Glycogen.Gain";
   Real LM_Insulin_InsulinDelayed(unit="uU/l", nominal=50.)
      "Insulin concentration delayed in liver. Original name: LM_Insulin.[InsulinDelayed]";
   Real LT_InterstitialProtein_Mass(unit="mg", nominal=75.)
      "Lower torso interstitial protein mass. Original name: LT_InterstitialProtein.Mass";
   Real LT_InterstitialWater_Vol(unit="ml", nominal=3402.17328522297)
      "Lower torso interstitial water. Original name: LT_InterstitialWater.Vol";
   Real LT_LymphFlow(unit="ml/min", nominal=1.2323274384069)
      "Flow of lymph water from lower torso. Original name: LT_LymphWater.Rate";
   Real LactateFromTissues(unit="mEq/min", nominal=4.46331709204733e-004)
      "Change of extracellular lactate mass. Original name: LacPool.Change";
   Real LacPool_Mass_mEq(unit="mEq", nominal=15.)
      "Extracellular lactate mass. Original name: LacPool.Mass";
   Real LacPool_Lac_mEq_per_litre(unit="meq/l", nominal=1.04449480166467)
      "Lactate extracellular concentration. Original name: LacPool.[Lac-(mEq/L)]";
   Real LeftAtrium_TMP(unit="mmHg", nominal=8.16)
      "Left atrium pressure gradient between inside and pericardium. Original name: LeftAtrium.TMP";
   Real leftAtrium_TMP(unit="mmHg", nominal=8.16)
      "Left atrium pressure gradient between inside and pericardium. Original name: LeftAtrium.TMP";
   Real leftHeart_CO2FromMetabolism(unit="ml/min", nominal=0.942645555600772)
      "LeftHeart carbondioxyde outflow from cells metabolism. Original name: LeftHeart-CO2.OutflowBase";
   Real LeftHeart_BloodFlow(unit="ml/min", nominal=186.157520521048)
      "LeftHeart blood flow. Original name: LeftHeart-Flow.BloodFlow";
   Real leftHeart_BloodFlow(unit="ml/min", nominal=186.157520521048)
      "LeftHeart blood flow. Original name: LeftHeart-Flow.BloodFlow";
   Real leftHeart_O2Use(unit="ml/min", nominal=26.4194382175104)
      "LeftHeart oxygen consumption. Original name: LeftHeart-Flow.O2Use";
   Real LeftHeart_PO2(unit="mmHg", nominal=17.2959653996553)
      "Partial oxygen pressure in leftHeart blood venules. Original name: LeftHeart-Flow.PO2";
   Real leftHeart_Fuel_FractUseDelay(unit="1", nominal=1.)
      "LeftHeart deficiency of nutrients needed by cells metabolism. Original name: LeftHeart-Fuel.FractUseDelay";
   Real leftHeart_LactateFromMetabolism(unit="mEq/min", nominal=0.)
      "Lactate flow from leftHeart cells. Original name: LeftHeart-Lactate.Outflux";
   Real leftHeart_cLactate(unit="meq/l", nominal=1.09840408347871)
      "LeftHeart intracellular lactate concentration. Original name: LeftHeart-Lactate.[Lac-(mEq/L)]";
   Real LeftHeart_O2Need(unit="ml/min", nominal=26.4194382175104)
      "Oxygen needed to be consumed by left heart cells if only aerobic metabolism is running. Original name: LeftHeart-Metabolism.O2Need";
   Real leftHeart_pH_intracellular(unit="1", nominal=6.95022466817416)
      "Acidity (pH) in leftHeart cells. Original name: LeftHeart-Ph.Ph";
   Real leftHeart_InterstitialWater(unit="ml", nominal=48.4115012265195)
      "LeftHeart interstitial water volume. Original name: LeftHeart-Size.IFV";
   Real LeftHeart_LiquidVol(unit="ml", nominal=154.77)
      "LeftHeart water volume = sum of leftHeart interstitial and leftHeart intracellular water. Original name: LeftHeart-Size.LiquidVol";
   Real LeftHeart_StructureEffect(unit="1", nominal=1.)
      "LeftHeart tissue structural damage effect. Original name: LeftHeart-Structure.Effect";
   Real LegMusclePump_Effect(unit="1", nominal=1.)
      "Effect to blood flow through veins with valves without exercise. Original name: LegMusclePump.Effect";
   Real Leptin(unit="ng/ml", nominal=7.96310041752106)
      "Leptin extracellular concentration. Original name: LeptinPool.[Leptin(nG/mL)]";
   Real LipidDeposits_Mass(unit="mg", nominal=12557.9)
      "Mass of lipids in fat cells. Original name: LipidDeposits.Mass";
   Real liver_CO2FromMetabolism(unit="ml/min", nominal=1.06673414961083)
      "Liver carbondioxyde outflow from cells metabolism. Original name: Liver-CO2.OutflowBase";
   Real liver_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Liver deficiency of nutrients needed by cells metabolism. Original name: Liver-Fuel.FractUseDelay";
   Real LiverFunctionEffect(unit="1", nominal=1.00000000000068)
      "Liver tissue function effect. Original name: Liver-Function.Effect";
   Real liver_LactateFromMetabolism(unit="mEq/min", nominal=2.69489936147329e-004)
      "Lactate flow from liver cells. Original name: Liver-Lactate.Outflux";
   Real liver_cLactate(unit="meq/l", nominal=1.38395043328294)
      "Liver intracellular lactate concentration. Original name: Liver-Lactate.[Lac-(mEq/L)]";
   Real liver_O2Use(unit="ml/min", nominal=29.8972575563573)
      "Oxygen comsuption by liver. Original name: Liver-O2.O2Use";
   Real Liver_PO2(unit="mmHg", nominal=44.4830320222965)
      "Partial oxygen pressure in hepatic vein. Original name: Liver-O2.PO2";
   Real liver_pH_intracellular(unit="1", nominal=6.96530584524228)
      "Acidity (pH) in liver cells. Original name: Liver-Ph.Ph";
   Real liver_InterstitialWater(unit="ml", nominal=323.204403426573)
      "Liver interstitial water volume. Original name: Liver-Size.IFV";
   Real Liver_LiquidVol(unit="ml", nominal=1033.274)
      "Liver water volume = sum of liver interstitial and liver intracellular water. Original name: Liver-Size.LiquidVol";
   Real Liver_StructureEffect(unit="1", nominal=1.)
      "Liver tissue structural damage effect. Original name: Liver-Structure.Effect";
   Real AlveolarVentilated_BloodFlow(unit="ml/min", nominal=5154.40525020509)
      "Blood flow through ventilated alveoli. Original name: LungBloodFlow.AlveolarVentilated";
   Real MD_Na(unit="meq/l", nominal=47.8340403745099)
      "Kidney nephron - Maculla densa sodium concentration. Original name: MD_Na.[Na+(mEq/L)]";
   Real MT_InterstitialProtein_Mass(unit="mg", nominal=150.)
      "Middle torso interstitional proteins. Original name: MT_InterstitialProtein.Mass";
   Real MT_InterstitialWater_Vol(unit="ml", nominal=5670.28880870495)
      "Middle torso interstitional water. Original name: MT_InterstitialWater.Vol";
   Real MT_LymphFlow(unit="ml/min", nominal=0.768959151661487)
      "Middle torso lymph flow. Original name: MT_LymphWater.Rate";
   Real Medulla_Volume(unit="ml", nominal=31.)
      "Kidney medulla interstitial water volume. Original name: Medulla.Volume";
   Real MedullaNa_Osmolarity(unit="Osm/l", nominal=838.709677419355)
      "Kidney medulla interstitial sodium osmolarity. Original name: MedullaNa.Osmolarity";
   Real MedullaNa_conc(unit="meq/l", nominal=419.354838709677)
      "Kidney medulla interstitial sodium concentration. Original name: MedullaNa.[Na+(mEq/L)]";
   Real MedullaUrea_Osmolarity(unit="Osm/l", nominal=317.267741935484)
      "Kidney medulla interstitial urea osmolarity. Original name: MedullaUrea.Osmolarity";
   Real MetabolicH2O_Rate(unit="ml/min", nominal=0.17577819959993)
      "Water synthesis in metabolism. Original name: MetabolicH2O.Rate";
   Real NephronADH(unit="ng/l", nominal=2.)
      "Nephron vasopresine concentration. Original name: NephronADH.[ADH]";
   Real NephronADH_conc(unit="ng/l", nominal=2.)
      "Nephron vasopresine concentration. Original name: NephronADH.[ADH]";
   Real NephronANP_Log10Conc(unit="1", nominal=1.30102999566398)
      "Decimal logarithm of nephrone atrial natriuretic peptide concentration. Original name: NephronANP.Log10Conc";
   Real NephronAldo_conc_in_nG_per_dl(unit="ng/dl", nominal=11.)
      "Nephrone aldosterone concentration. Original name: NephronAldo.[Aldo(nG/dL)]";
   Real Osmreceptors(unit="Osm/l", nominal=0.260447746661318)
      "Osmolarity in hypothalamic osmoreceptors. Original name: OsmBody.[Osm]-Osmoreceptors";
   Real OsmCell_Electrolytes(unit="mOsm", nominal=7923.4702850513)
      "Intracellular electrolites osmoles. Original name: OsmCell.Electrolytes";
   Real OsmECFV_Electrolytes(unit="mOsm", nominal=4330.66)
      "Extracellular electrolites osmoles. Original name: OsmECFV.Electrolytes";
   Real otherTissue_CO2FromMetabolism(unit="ml/min", nominal=0.283139288504164)
      "OtherTissue carbondioxyde outflow from cells metabolism. Original name: OtherTissue-CO2.OutflowBase";
   Real OtherTissue_BloodFlow(unit="ml/min", nominal=375.121095215705)
      "OtherTissue blood flow. Original name: OtherTissue-Flow.BloodFlow";
   Real otherTissue_BloodFlow(unit="ml/min", nominal=375.121095215705)
      "OtherTissue blood flow. Original name: OtherTissue-Flow.BloodFlow";
   Real otherTissue_O2Use(unit="ml/min", nominal=7.93551817556513)
      "OtherTissue oxygen consumption. Original name: OtherTissue-Flow.O2Use";
   Real OtherTissue_PO2(unit="mmHg", nominal=56.8995160542686)
      "Partial oxygen pressure in otherTissue blood venules. Original name: OtherTissue-Flow.PO2";
   Real otherTissue_Fuel_FractUseDelay(unit="1", nominal=1.)
      "OtherTissue deficiency of nutrients needed by cells metabolism. Original name: OtherTissue-Fuel.FractUseDelay";
   Real OtherTissueFunctionEffect(unit="1", nominal=1.00000000000068)
      "OtherTissue tissue function effect. Original name: OtherTissue-Function.Effect";
   Real otherTissue_LactateFromMetabolism(unit="mEq/min", nominal=3.58314143292407e-005)
      "Lactate flow from otherTissue cells. Original name: OtherTissue-Lactate.Outflux";
   Real otherTissue_cLactate(unit="meq/l", nominal=1.30340035360388)
      "OtherTissue intracellular lactate concentration. Original name: OtherTissue-Lactate.[Lac-(mEq/L)]";
   Real otherTissue_pH_intracellular(unit="1", nominal=7.01567605859914)
      "Acidity (pH) in otherTissue cells. Original name: OtherTissue-Ph.Ph";
   Real otherTissue_InterstitialWater(unit="ml", nominal=760.752162131021)
      "OtherTissue interstitial water volume. Original name: OtherTissue-Size.IFV";
   Real OtherTissue_LiquidVol(unit="ml", nominal=2432.1)
      "OtherTissue water volume = sum of otherTissue interstitial and otherTissue intracellular water. Original name: OtherTissue-Size.LiquidVol";
   Real OtherTissue_StructureEffect(unit="1", nominal=1.)
      "OtherTissue tissue structural damage effect. Original name: OtherTissue-Structure.Effect";
   Real ctPO4(unit="meq/l", nominal=0.169215883872323)
      "Extracellular phosphates concentration. Original name: PO4Pool.[PO4--(mEq/L)]";
   Real PT_Na_FractReab(unit="1", nominal=0.582787577230245)
      "Proximal tubule sodium reabsorbtion fraction (=reabsorbed/inflowed). Original name: PT_Na.FractReab";
   Real PT_Na_Reab(unit="mEq/min", nominal=10.2355077368739)
      "Proximal tubule sodium reabsorbtion. Original name: PT_Na.Reab";
   Real Pericardium_Pressure(unit="mmHg", nominal=-3.34522126058954)
      "Pericardium cavity pressure. Original name: Pericardium-Cavity.Pressure";
   Real PeritoneumSpace_Gain(unit="ml/min", nominal=0.)
      "Water inflow to pericardium interstitial space. Original name: PeritoneumSpace.Gain";
   Real PeritoneumSpace_Loss(unit="ml/min", nominal=0.)
      "Water outflow from pericardium interstitial space. Original name: PeritoneumSpace.Loss";
   Real PeritoneumSpace_Vol(unit="ml", nominal=0.)
      "Water in pericardium interstitial space. Original name: PeritoneumSpace.Volume";
   Real PlasmaProtein_Mass(unit="mg", nominal=210.)
      "Plasma proteins. Original name: PlasmaProtein.Mass";
   Real PlasmaVol(unit="ml", nominal=3020.43210336)
      "Plasma volume. Original name: PlasmaVol.Vol";
   Real PlasmaVol_Vol(unit="ml", nominal=3020.43210336)
      "Plasma volume. Original name: PlasmaVol.Vol";
   Real PortalVein_Glucagon(unit="ng/l", nominal=160.397183960179)
      "Glucagon portal vein concentration. Original name: PortalVein-Glucagon.[Glucagon]";
   Real PortalVein_Insulin(unit="uU/l", nominal=52.444538843581)
      "Insulin portal vein concentration. Original name: PortalVein-Insulin.[Insulin]";
   Real PortalVein_BloodFlow(unit="ml/min", nominal=985.260894008123)
      "Portal vein blood flow. Original name: PortalVein.BloodFlow";
   Real PortalVein_PlasmaFlow(unit="ml/min", nominal=551.746100644549)
      "Portal vein plasma flow. Original name: PortalVein.PlasmaFlow";
   Real PulmCapys_Pressure(unit="mmHg", nominal=9.04347826086957)
      "Blood pressure in pulmonary capylaries. Original name: PulmCapys.Pressure";
   Real RBCH2O_Vol(unit="ml", nominal=1566.3097907424)
      "Intracellular water in erythrocytes. Original name: RBCH2O.Vol";
   Real RespiratoryCenter_MotorNerveActivity(unit="1", nominal=0.943462424759193)
      "Neural activity from respiratory center to respiratory muscle. Original name: RespiratoryCenter-Output.MotorNerveActivity";
   Real RespiratoryCenter_RespRate(unit="1/min", nominal=11.7241515181155)
      "Respiration rate. Original name: RespiratoryCenter-Output.Rate";
   Real respiratoryMuscle_CO2FromMetabolism(unit="ml/min", nominal=0.20215249198237)
      "RespiratoryMuscle carbondioxyde outflow from cells metabolism. Original name: RespiratoryMuscle-CO2.OutflowBase";
   Real RespiratoryMuscle_BloodFlow(unit="ml/min", nominal=98.2460011279228)
      "RespiratoryMuscle blood flow. Original name: RespiratoryMuscle-Flow.BloodFlow";
   Real respiratoryMuscle_BloodFlow(unit="ml/min", nominal=98.2460011279228)
      "RespiratoryMuscle blood flow. Original name: RespiratoryMuscle-Flow.BloodFlow";
   Real respiratoryMuscle_O2Use(unit="ml/min", nominal=5.66570885600814)
      "RespiratoryMuscle oxygen consumption. Original name: RespiratoryMuscle-Flow.O2Use";
   Real RespiratoryMuscle_PO2(unit="mmHg", nominal=36.8940260458383)
      "Partial oxygen pressure in respiratoryMuscle blood venules. Original name: RespiratoryMuscle-Flow.PO2";
   Real respiratoryMuscle_Fuel_FractUseDelay(unit="1", nominal=1.)
      "RespiratoryMuscle deficiency of nutrients needed by cells metabolism. Original name: RespiratoryMuscle-Fuel.FractUseDelay";
   Real RespiratoryMuscleFunctionEffect(unit="1", nominal=1.00000000000068)
      "RespiratoryMuscle tissue function effect. Original name: RespiratoryMuscle-Function.Effect";
   Real respiratoryMuscle_GlucoseToCellStorageFlow(unit="mg/min", nominal=0.)
      "Glycogen synthesis in skeletal muscle cells of respiratory muscles. Original name: RespiratoryMuscle-Glycogen.Synthesis";
   Real respiratoryMuscle_LactateFromMetabolism(unit="mEq/min", nominal=1.1082997070175e-005)
      "Lactate flow from respiratoryMuscle cells. Original name: RespiratoryMuscle-Lactate.Outflux";
   Real respiratoryMuscle_cLactate(unit="meq/l", nominal=1.23705408515535)
      "RespiratoryMuscle intracellular lactate concentration. Original name: RespiratoryMuscle-Lactate.[Lac-(mEq/L)]";
   Real RespiratoryMuscle_O2Need(unit="ml/min", nominal=5.66570885600814)
      "Oxygen needed to be consumed by respiratory muscle cells if only aerobic metabolism is running. Original name: RespiratoryMuscle-Metabolism.O2Need";
   Real respiratoryMuscle_pH_intracellular(unit="1", nominal=7.06537038555618)
      "Acidity (pH) in respiratoryMuscle cells. Original name: RespiratoryMuscle-Ph.Ph";
   Real respiratoryMuscle_InterstitialWater(unit="ml", nominal=761.096238188068)
      "RespiratoryMuscle interstitial water volume. Original name: RespiratoryMuscle-Size.IFV";
   Real RespiratoryMuscle_LiquidVol(unit="ml", nominal=2433.2)
      "RespiratoryMuscle water volume = sum of respiratoryMuscle interstitial and respiratoryMuscle intracellular water. Original name: RespiratoryMuscle-Size.LiquidVol";
   Real RespiratoryMuscle_StructureEffect(unit="1", nominal=1.)
      "RespiratoryMuscle tissue structural damage effect. Original name: RespiratoryMuscle-Structure.Effect";
   Real RightAtrium_Pressure(unit="mmHg", nominal=0.734778739410459)
      "Blood pressure in right atrium. Original name: RightAtrium.Pressure";
   Real RightAtrium_TMP(unit="mmHg", nominal=4.8)
      "Right atrium pressure gradient between inside and pericardium. Original name: RightAtrium.TMP";
   Real rightAtrium_TMP(unit="mmHg", nominal=4.8)
      "Right atrium pressure gradient between inside and pericardium. Original name: RightAtrium.TMP";
   Real rightHeart_CO2FromMetabolism(unit="ml/min", nominal=0.181290198493389)
      "RightHeart carbondioxyde outflow from cells metabolism. Original name: RightHeart-CO2.OutflowBase";
   Real RightHeart_BloodFlow(unit="ml/min", nominal=34.955556585178)
      "RightHeart blood flow. Original name: RightHeart-Flow.BloodFlow";
   Real rightHeart_BloodFlow(unit="ml/min", nominal=34.955556585178)
      "RightHeart blood flow. Original name: RightHeart-Flow.BloodFlow";
   Real rightHeart_O2Use(unit="ml/min", nominal=5.08100332100305)
      "RightHeart oxygen consumption. Original name: RightHeart-Flow.O2Use";
   Real RightHeart_PO2(unit="mmHg", nominal=16.7304160413847)
      "Partial oxygen pressure in rightHeart blood venules. Original name: RightHeart-Flow.PO2";
   Real rightHeart_Fuel_FractUseDelay(unit="1", nominal=1.)
      "RightHeart deficiency of nutrients needed by cells metabolism. Original name: RightHeart-Fuel.FractUseDelay";
   Real rightHeart_LactateFromMetabolism(unit="mEq/min", nominal=1.73444291670095e-006)
      "Lactate flow from rightHeart cells. Original name: RightHeart-Lactate.Outflux";
   Real rightHeart_cLactate(unit="meq/l", nominal=1.16301608838922)
      "RightHeart intracellular lactate concentration. Original name: RightHeart-Lactate.[Lac-(mEq/L)]";
   Real rightHeart_pH_intracellular(unit="1", nominal=6.92622678830646)
      "Acidity (pH) in rightHeart cells. Original name: RightHeart-Ph.Ph";
   Real rightHeart_InterstitialWater(unit="ml", nominal=8.06858353775326)
      "RightHeart interstitial water volume. Original name: RightHeart-Size.IFV";
   Real RightHeart_LiquidVol(unit="ml", nominal=25.795)
      "RightHeart water volume = sum of rightHeart interstitial and rightHeart intracellular water. Original name: RightHeart-Size.LiquidVol";
   Real RightHeart_StructureEffect(unit="1", nominal=1.)
      "RightHeart tissue structural damage effect. Original name: RightHeart-Structure.Effect";
   Real skeletalMuscle_CO2FromMetabolism(unit="ml/min", nominal=1.04285332261612)
      "SkeletalMuscle carbondioxyde outflow from cells metabolism. Original name: SkeletalMuscle-CO2.OutflowBase";
   Real SkeletalMuscle_BloodFlow(unit="ml/min", nominal=643.197470590973)
      "SkeletalMuscle blood flow. Original name: SkeletalMuscle-Flow.BloodFlow";
   Real skeletalMuscle_BloodFlow(unit="ml/min", nominal=643.197470590973)
      "SkeletalMuscle blood flow. Original name: SkeletalMuscle-Flow.BloodFlow";
   Real skeletalMuscle_O2Use(unit="ml/min", nominal=29.2279518670436)
      "SkeletalMuscle oxygen consumption. Original name: SkeletalMuscle-Flow.O2Use";
   Real SkeletalMuscle_PO2(unit="mmHg", nominal=41.696434578854)
      "Partial oxygen pressure in skeletalMuscle blood venules. Original name: SkeletalMuscle-Flow.PO2";
   Real skeletalMuscle_Fuel_FractUseDelay(unit="1", nominal=1.)
      "SkeletalMuscle deficiency of nutrients needed by cells metabolism. Original name: SkeletalMuscle-Fuel.FractUseDelay";
   Real skeletalMuscle_GlucoseToCellStorageFlow(unit="mg/min", nominal=0.)
      "Skeletal muscle glycogen synthesis rate. Original name: SkeletalMuscle-Glycogen.Synthesis";
   Real skeletalMuscle_LactateFromMetabolism(unit="mEq/min", nominal=0.)
      "Lactate flow from skeletalMuscle cells. Original name: SkeletalMuscle-Lactate.Outflux";
   Real skeletalMuscle_cLactate(unit="meq/l", nominal=0.93550771505128)
      "SkeletalMuscle intracellular lactate concentration. Original name: SkeletalMuscle-Lactate.[Lac-(mEq/L)]";
   Real SkeletalMuscle_O2Need(unit="ml/min", nominal=29.2279518670436)
      "Oxygen needed to be consumed by skeletal muscle cells if only aerobic metabolism is running. Original name: SkeletalMuscle-Metabolism.O2Need";
   Real skeletalMuscle_pH_intracellular(unit="1", nominal=7.39907006272829)
      "Acidity (pH) in skeletalMuscle cells. Original name: SkeletalMuscle-Ph.Ph";
   Real skeletalMuscle_InterstitialWater(unit="ml", nominal=6770.79120985489)
      "SkeletalMuscle interstitial water volume. Original name: SkeletalMuscle-Size.IFV";
   Real SkeletalMuscle_LiquidVol(unit="ml", nominal=21646.)
      "SkeletalMuscle water volume = sum of skeletalMuscle interstitial and skeletalMuscle intracellular water. Original name: SkeletalMuscle-Size.LiquidVol";
   Real skeletalMuscle_SizeMass(unit="g", nominal=27400.)
      "Weight of skeletal muscle tissues. Original name: SkeletalMuscle-Size.Mass";
   Real SkeletalMuscle_StructureEffect(unit="1", nominal=1.)
      "SkeletalMuscle tissue structural damage effect. Original name: SkeletalMuscle-Structure.Effect";
   Real skin_CO2FromMetabolism(unit="ml/min", nominal=0.210001458708568)
      "Skin carbondioxyde outflow from cells metabolism. Original name: Skin-CO2.OutflowBase";
   Real Skin_BloodFlow(unit="ml/min", nominal=141.322057495783)
      "Skin blood flow. Original name: Skin-Flow.BloodFlow";
   Real skin_BloodFlow(unit="ml/min", nominal=141.322057495783)
      "Skin blood flow. Original name: Skin-Flow.BloodFlow";
   Real skin_O2Use(unit="ml/min", nominal=5.88569110730292)
      "Skin oxygen consumption. Original name: Skin-Flow.O2Use";
   Real Skin_PO2(unit="mmHg", nominal=43.4499604248239)
      "Partial oxygen pressure in skin blood venules. Original name: Skin-Flow.PO2";
   Real skin_Fuel_FractUseDelay(unit="1", nominal=1.)
      "Skin deficiency of nutrients needed by cells metabolism. Original name: Skin-Fuel.FractUseDelay";
   Real skin_LactateFromMetabolism(unit="mEq/min", nominal=2.62677924946138e-006)
      "Lactate flow from skin cells. Original name: Skin-Lactate.Outflux";
   Real skin_cLactate(unit="meq/l", nominal=1.17061750073164)
      "Skin intracellular lactate concentration. Original name: Skin-Lactate.[Lac-(mEq/L)]";
   Real skin_pH_intracellular(unit="1", nominal=7.1177616785739)
      "Acidity (pH) in skin cells. Original name: Skin-Ph.Ph";
   Real skin_InterstitialWater(unit="ml", nominal=470.283154771904)
      "Skin interstitial water volume. Original name: Skin-Size.IFV";
   Real Skin_LiquidVol(unit="ml", nominal=1503.48)
      "Skin water volume = sum of skin interstitial and skin intracellular water. Original name: Skin-Size.LiquidVol";
   Real skinSizeMass(unit="g", nominal=2244.)
      "Weight of skin. Original name: Skin-Size.Mass";
   Real Skin_StructureEffect(unit="1", nominal=1.)
      "Skin tissue structural damage effect. Original name: Skin-Structure.Effect";
   Real SplanchnicVeins_Pressure(unit="mmHg", nominal=8.112)
      "Splanchnic (=portal vein) veins blood pressure. Original name: SplanchnicVeins.Pressure";
   Real SplanchnicCirculation_DeoxygenatedBloodVolume(unit="ml", nominal=1007.)
      "Splanchnic (=portal vein and venules) veins blood volume. Original name: SplanchnicVeins.Vol";
   Real Status_Posture(unit="1", nominal=1.)
      "Posture of body (0..NONE Original name: Status.Posture";
   Real SweatDuct_ClRate(unit="mEq/min", nominal=0.)
      "Chloride outflow through sweat ducts. Original name: SweatDuct.ClOutflow";
   Real SweatDuct_H2OOutflow(unit="mEq/min", nominal=0.)
      "Water outflow through sweat ducts. Original name: SweatDuct.H2OOutflow";
   Real SweatDuct_KRate(unit="mEq/min", nominal=0.)
      "Potassium outflow through sweat ducts. Original name: SweatDuct.KOutflow";
   Real SweatDuct_NaRate(unit="mEq/min", nominal=0.)
      "Sodium outflow through sweat ducts. Original name: SweatDuct.NaOutflow";
   Real SympsCNS_PituitaryNA(unit="1", nominal=1.00901292567802)
      "Sympathetis pituitary nerve activity. Original name: SympsCNS.PituitaryNA";
   Real SystemicArtys_Pressure(unit="mmHg", nominal=96.1290322580645)
      "Mean systemic arteries blood pressure. Original name: SystemicArtys.Pressure";
   Real ThiazidePool_Thiazide_conc(unit="ug/ml", nominal=0.)
      "Tiazide extracellular conentration. Original name: ThiazidePool.[Thiazide]";
   Real Thorax_AvePressure(unit="mmHg", nominal=-4.)
      "Intrathorax pressure. Original name: Thorax.AvePressure";
   Real Thorax_LungInflation(unit="1", nominal=1.)
      "Lungs inflation effect. Original name: Thorax.LungInflation";
   Real ThyroidEffect(unit="1", nominal=0.985356922586166)
      "Triiodothyronine  and thyroxine effect to metabolism. Original name: Thyroid.Effect";
   Real Transfusion_ClRate(unit="mEq/min", nominal=0.)
      "Chloride intake by transfusion. Original name: Transfusion.ClRate";
   Real Transfusion_KRate(unit="mEq/min", nominal=0.)
      "Potassium intake by transfusion. Original name: Transfusion.KRate";
   Real Transfusion_NaRate(unit="mEq/min", nominal=0.)
      "Sodium intake by transfusion. Original name: Transfusion.NaRate";
   Real Transfusion_PlasmaRate(unit="ml/min", nominal=0.)
      "Plasma intake by transfusion. Original name: Transfusion.PlasmaRate";
   Real Transfusion_ProteinRate(unit="mg/min", nominal=0.)
      "Protein intake by transfusion. Original name: Transfusion.ProteinRate";
   Real Transfusion_RBCRate(unit="ml/min", nominal=0.)
      "Erythrocytes intake by transfusion. Original name: Transfusion.RBCRate";
   Real UT_InterstitialProtein_Mass(unit="mg", nominal=75.)
      "Upper tissue interstitial protein. Original name: UT_InterstitialProtein.Mass";
   Real UT_InterstitialWater_Vol(unit="ml", nominal=2268.11552348198)
      "Upper tissue interstitial water. Original name: UT_InterstitialWater.Vol";
   Real UT_LymphFlow(unit="ml/min", nominal=0.37412994236873)
      "Upper tissue lypmh outflow. Original name: UT_LymphWater.Rate";
   Real UreaICF_Osmoles(unit="Osm/l", nominal=169.2005)
      "Intracellular urea osmoles. Original name: UreaCell.Osmoles";
   Real UreaECF_Osmoles(unit="Osm/l", nominal=95.3175284466562)
      "Extracellular urea osmoles. Original name: UreaPool.Osmoles";
   Real Urine_pH(unit="1", nominal=5.7)
      "Acidity (pH) of urine. Original name: Urine_pH";
   Real VasaRecta_Outflow(unit="ml/min", nominal=24.3304317899118)
      "Kidney vasa recta blood outflow to kidney veins. Original name: VasaRecta.Outflow";
   Real VeinsVol(unit="ml", nominal=3795.128756)
      "Volume of deoxygenated blood in body. Original name: VeinsVol.Vol";
   Real WeightCore(unit="g", nominal=41757.328756)
      "Weight of whole body. Original name: Weight.Core";
   Real cDPG(unit="mmol/l", nominal=5.4)
      "Blood 2,3-diphosphoglycerate concentration. Original name: cDPG";
   Real ctAlb(unit="mmol/l", nominal=0.66)
      "Blood molar albumin concentration. Original name: ctAlb";
   Real ctGlb(unit="g/l", nominal=28)
      "Blood globolins concentration. Original name: ctGlb";
   Real ctHb(unit="mmol/l", nominal=8.4)
      "Hemoglobin concentration in blood. Original name: ctHb";
   Real ctHb_ery(unit="mmol/l", nominal=21)
      "Hemoglobin concentration in erythrocytes. Original name: ctHb_ery";
   Real pCO(unit="mmHg", nominal=0)
      "Partial pressure of carbonmonoxyde. Original name: pCO";
  end BusConnectorInternal;

end Interfaces;
