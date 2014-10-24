within Physiomodel;
package Substances "Definitions of substances"
    extends Modelica.Icons.Package;

  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Water=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="H2O",
      mw=0.018015,
      storeUnit="g") "H2O";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Oxygen=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="O2",
      mw=0.032,
      storeUnit="ml_STP") "O2";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition CarbonDioxide=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="CO2",
      mw=0.044,
      storeUnit="ml_STP") "CO2";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Bicarbonate=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="HCO3",
      mw=0.06102,
      storeUnit="mmol/l") "HCO3-";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Sodium=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Na",
      mw=0.02299,
      storeUnit="mmol/l") "Na+";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Potassium=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="K",
      mw=0.0391,
      storeUnit="mmol/l") "K+";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Chloride=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Cl",
      mw=0.03545,
      storeUnit="mmol/l") "Cl-";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Phosphates=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="PO4",
      mw=0.095,
      storeUnit="mmol/l") "H2PO4^-, HPO4^2-";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Diphosphoglycerate=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="2,3-DPG",
      mw=0.26604,
      storeUnit="mmol/l") "2,3-BPG";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Sulphates=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="SO4",
      mw=0.09607,
      storeUnit="mmol/l") "SO4^2-";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Amonium=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="NH4",
      mw=0.01804,
      storeUnit="mmol/l") "NH4+";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Magnesium=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Mg",
      mw=0.0243,
      storeUnit="mmol/l") "Mg^2+";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Calcium=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Ca",
      mw=0.0401,
      storeUnit="mmol/l") "Ca^2+";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Iron=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Fe",
      mw=0.05585,
      storeUnit="mmol/l") "Fe^2+, Fe^3+";

  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Glucose=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Glu",
      mw=0.1806,
      storeUnit="mg/dl") "Glu";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition FattyAcids=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="FA",
      mw=0.255,
      storeUnit="mg/dl") "FA";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition KetoAcids=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="KA",
      mw=0.102,
      storeUnit="mg/dl") "KA";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition AminoAcids=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="AA",
      mw=0.1,
      storeUnit="mg/dl") "AA";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Lactate=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Lac",
      mw=0.09008,
      storeUnit="mmol/l") "Lac";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Triglycerides=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Triglyceride",
      mw=0.80645,
      storeUnit="mg/dl") "Triglyceride";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Urea=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Urea",
      mw=0.06006,
      storeUnit="mg/dl") "Urea";

  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Hemoglobins=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Hb",
      mw=64.500,
      storeUnit="g/dl") "Hb";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Albumins=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Alb",
      mw=66.438,
      storeUnit="g/dl") "Alb";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Globulins=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Glb",
      mw=34.500,
      storeUnit="g/dl") "Glb";

  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Insulin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Insulin",
      mw=5.808,
      storeUnit="IU/m3") "Insulin";
      //,molpIU=6.622e-9
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Leptin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Leptin",
      mw=16.026,
      storeUnit="ng/ml") "Leptin";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Glucagon=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Glucagon",
      mw=3.485,
      storeUnit="ng/l") "Glucagon";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Renin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="PRA",
      mw=48,
      storeUnit="GU/l") "PRA";
      //,
      //molpIU=0.0125e-9,
      //molpGU=0.14e-12)
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Angionensinogen=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="AGT",
      mw=56.8,
      storeUnit="mg/dl") "AGT";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition AngiotensinI=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="AI",
      mw=1.2965,
      storeUnit="pmol/l") "AI";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition AngiotensinII=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="AII",
      mw=1.046,
      storeUnit="pmol/l") "AII";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Aldosterone=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="Aldo",
      mw=0.36044,
      storeUnit="pmol/l") "Aldo";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition AtrialNatriureticPeptide=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="ANP",
      mw=3.060,
      storeUnit="pmol/l") "ANP";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Vasopressin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="ADH",
      mw=1.084,
      storeUnit="pmol/l") "ADH";
      //,molpIU=2.305e-9
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Thyrotropin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="TSH",
      mw=28,
      storeUnit="pmol/l") "TSH";
      //,molpIU=6.21e-9
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Thyroxine=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="T3-4",
      mw=0.777,
      storeUnit="pmol/l") "T3, T4";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Erythropoietin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="EPO",
      mw=34,
      storeUnit="pmol/l") "EPO";
      //,molpIU=0.45e-9
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Epinephrine=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="EPI",
      mw=0.183204,
      storeUnit="pmol/l") "EPI";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Norepinephrine=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="NE",
      mw=0.16918,
      storeUnit="pmol/l") "NE";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Calcitriol=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="D3",
      mw=0.41664,
      storeUnit="mmol/l") "Vitamin D3";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Parathormone=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(
      shortName="PTH",
      mw=9.4,
      storeUnit="pmol/l") "PTH";

  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Furosemide=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(mw=0.33075,
      storeUnit="mg/l") "Furosemide";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Chlorothiazide=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(mw=0.29573,
      storeUnit="mg/l") "Chlorothiazide";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Digoxin=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(mw=0.78092,
      storeUnit="mg/l") "Digoxin";
  constant Physiolibrary.Chemical.Interfaces.SubstanceDefinition Desglymidodrine=
      Physiolibrary.Chemical.Interfaces.SubstanceDefinition(mw=0.197231,
      storeUnit="ug/l") "Digoxin";

  annotation (Documentation(info="<html>
<p>Invariant&nbsp;properties&nbsp;of&nbsp;substance&nbsp;(molar&nbsp;weight,&nbsp;enthalpy,&nbsp;entropy,&nbsp;...) to recalculate units, or other substances stafs.</p>
<p>The change of definition of international units must be accompanied with change of displayunits.mos file!</p>
</html>"));
end Substances;
