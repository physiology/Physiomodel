within Physiomodel;
package Anatomies
  partial package Anatomy
    replaceable type Parts = enumeration(:);

    replaceable record Parameters

    end Parameters;

  end Anatomy;

  package Basic
    extends Anatomy;
    redeclare replaceable type Parts = enumeration(
        WholeBody);

  end Basic;

  package ThreeTorsos
    extends Anatomy;
    redeclare replaceable type Parts = enumeration(
        UpperTorso,
        MiddleTorso,
        LowerTorso);

    redeclare replaceable record extends Parameters
      parameter Physiolibrary.Types.Fraction InterstitialWaterFract_start[Parts] = {0.00227, 0.00567,0.0034} ./ 0.01134;
      parameter Physiolibrary.Types.Fraction IntracellularWaterFract_start[Parts] = {0.00498, 0.01246, 0.00747} ./ 0.02491;

      parameter Physiolibrary.Types.Fraction NormalLymphFlowFract[Parts] = {6.6666666666667e-09, 1.3333333333333e-08, 2.1666666666667e-08} ./ 4.1666666666666696E-008;

      parameter Physiolibrary.Types.OsmoticPermeability CapillaryPermeabilityFract[Parts] = {1.4814814814815e-11, 3.7268518518519e-11, 1.5509259259259e-11} ./ 6.759259259259301E-011
       "Capillary wall permeability for water. 0.6, 3.6, 1.3 ml/(kPa.min)";

      parameter Real[ :,3] InterstitialPressureVolumeData[Parts] = {
    {{600.0,-30.0,0.01},{2000.0,-4.8,0.0004},{5000.0,0.0,0.0004},{12000.0,50.0,0.01}},
    {{1200.0,-30.0,0.01},{4800.0,-4.8,0.0004},{12000.0,0.0,0.0004},{24000.0,50.0,0.01}},
    {{600.0,-30.0,0.02},{3000.0,-4.8,0.0004},{4000.0,-4.0,0.0004},{6000.0,50.0,0.03}}};

      parameter Physiolibrary.Types.Fraction ICFVFract[Parts] = {0.94,0.94,0.94} "Ratio between non-RBC-ICFV and total ICFV, because red cells are not part of any torso ICF!";
      parameter Physiolibrary.Types.Fraction SizeFract[Parts] = {0.2,0.5,0.3};
      parameter Physiolibrary.Types.Fraction CalsFract[Parts] = {0.3,0.5,0.2};
      parameter Physiolibrary.Types.Fraction SweatFract[Parts] = {0.33,0.34,0.33};
      parameter Physiolibrary.Types.Fraction SkinFract[Parts] = {0.33,0.34,0.33};
      parameter Physiolibrary.Types.Fraction LungFract[Parts] = {0,1,0};
    end Parameters;

    /*
  UT:
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
  MT:
  InterstitialPressureVolumeData={{1200.0,-30.0,0.01},{4800.0,-4.8,0.0004},
      {12000.0,0.0,0.0004},{24000.0,50.0,0.01}},
  CapillaryConductance(displayUnit="l/(kPa.d)") = 3.7268518518519e-11,
    InterstitialWater_start=0.00567,
    IntracellularWater_start=0.01246,
    NormalLymphFlow=1.3333333333333e-08,
    ICFVFract=0.94,
    SizeFract=0.5,
    CalsFract=0.5,
    SweatFract=0.34,
    SkinFract=0.34,
    LungFract=1)
  annotation (Placement(transformation(extent={{22,-62},{42,-42}})));
QHP.Water.WaterCompartments.Torso LowerTorso(
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
  SkinFract=0.33) */

  end ThreeTorsos;

  package Tissues
    extends Anatomy;
    redeclare replaceable type Parts = enumeration(
        SkeletalMuscle,
        RespiratoryMuscle,
        Brain,
        Kidney,
        LeftHeart,
        RightHeart,
        GITract,
        Liver,
        Skin,
        Bone,
        Fat,
        OtherTissue);

  end Tissues;

  package ThreeTorsoTissues
    extends Anatomy;
    redeclare replaceable type Parts = enumeration(
        SkeletalMuscle_UT,
        SkeletalMuscle_MT,
        SkeletalMuscle_LT,
        RespiratoryMuscle_UT,
        RespiratoryMuscle_MT,
        Brain_UT,
        Brain_MT,
        Brain_LT,
        Kidney_MT,
        LeftHeart_MT,
        RightHeart_MT,
        GITract_MT,
        Liver_MT,
        Skin_UT,
        Skin_MT,
        Skin_LT,
        Bone_UT,
        Bone_MT,
        Bone_LT,
        Fat_UT,
        Fat_MT,
        Fat_LT,
        OtherTissue_UT,
        OtherTissue_MT,
        OtherTissue_LT);

  end ThreeTorsoTissues;
end Anatomies;
