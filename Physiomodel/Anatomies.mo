within Physiomodel;
package Anatomies
  partial package Anatomy
    replaceable type Parts = enumeration(:) "Anatomical division of the body";

    replaceable record Parameters "Parameters of anatomical division of the body"

    end Parameters;

    replaceable record State "Current state of anatomical division of the body"

    end State;

    replaceable function InterstitialWater_start
       "Start value of interstitial water volume of selected body part"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";

         parameter Physiolibrary.Types.Volume totalVolume "Total volume of body interstitial water";
         output Physiolibrary.Types.Volume partVolume "Interstitial water in selected body part";
    end InterstitialWater_start;

   replaceable function CellularWater_start
       "Start value of intracellular water volume of selected body part"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";

         parameter Physiolibrary.Types.Volume totalVolume "Total volume of body intracellular water";
         output Physiolibrary.Types.Volume partVolume "Intracellular water in selected body part";
   end CellularWater_start;

    replaceable function NormalLymphFlow
       "Normal lymph flow of selected body part"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";

         parameter Physiolibrary.Types.Volume totalVolume "Normal lymph flow of whole body";
         output Physiolibrary.Types.Volume partVolume "Normal lymph flow of selected body part";
    end NormalLymphFlow;

    replaceable function NormalCapillaryPermeability
       "Capillary wall permeability for water of selected body part"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";

         parameter Physiolibrary.Types.OsmoticPermeability totalPermeability "Capillary wall permeability for water of whole body";
         output Physiolibrary.Types.OsmoticPermeability partPermeability "Capillary wall permeability for water of selected body part";
    end NormalCapillaryPermeability;



    replaceable function InterstitialPressure
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";

         input State state "Current state of the body parts";
         output Physiolibrary.Types.Pressure p "Interstitial hydraulic pressure";
    end InterstitialPressure;


    replaceable function ICFVFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction ICFVFract;
    end ICFVFract;

    replaceable function SizeFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction SizeFract;
    end SizeFract;

    replaceable function CalsFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction CalsFract;
    end CalsFract;

    replaceable function SweatFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction SweatFract;
    end SweatFract;

    replaceable function SkinFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction SkinFract;
    end SkinFract;

    replaceable function LungFract
       "Interstitial hydraulic pressure based on volume of interstitial water"

         parameter Parts part "Part of the body";
         parameter Parameters params "Parameters of the anatomical division";
         input State state "Current state of the body parts";
         output Physiolibrary.Types.Fraction LungFract;
    end LungFract;

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
      parameter Physiolibrary.Types.Fraction InterstitialWaterFract_start[Parts]={
          0.00227,0.00567,0.0034} ./ 0.01134;
      parameter Physiolibrary.Types.Fraction IntracellularWaterFract_start[Parts]=
         {0.00498,0.01246,0.00747} ./ 0.02491;

      parameter Physiolibrary.Types.Fraction NormalLymphFlowFract[Parts]={6.6666666666667e-09,
          1.3333333333333e-08,2.1666666666667e-08} ./ 4.1666666666666696E-008;

      parameter Physiolibrary.Types.OsmoticPermeability
        CapillaryPermeabilityFract[Parts]={1.4814814814815e-11,3.7268518518519e-11,
          1.5509259259259e-11} ./ 6.759259259259301E-011
        "Capillary wall permeability for water. 0.6, 3.6, 1.3 ml/(kPa.min)";

      parameter Real[:,3] InterstitialPressureVolumeData[Parts]={{{600.0,-30.0,0.01},
          {2000.0,-4.8,0.0004},{5000.0,0.0,0.0004},{12000.0,50.0,0.01}},{{1200.0,-30.0,
          0.01},{4800.0,-4.8,0.0004},{12000.0,0.0,0.0004},{24000.0,50.0,0.01}},{{600.0,
          -30.0,0.02},{3000.0,-4.8,0.0004},{4000.0,-4.0,0.0004},{6000.0,50.0,0.03}}};

      parameter Physiolibrary.Types.Fraction ICFVFract[Parts]={0.94,0.94,0.94}
        "Ratio between non-RBC-ICFV and total ICFV, because red cells are not part of any torso ICF!";
      parameter Physiolibrary.Types.Fraction SizeFract[Parts]={0.2,0.5,0.3};
      parameter Physiolibrary.Types.Fraction CalsFract[Parts]={0.3,0.5,0.2};
      parameter Physiolibrary.Types.Fraction SweatFract[Parts]={0.33,0.34,0.33};
      parameter Physiolibrary.Types.Fraction SkinFract[Parts]={0.33,0.34,0.33};
      parameter Physiolibrary.Types.Fraction LungFract[Parts]={0,1,0};

    protected
      parameter Real[:,:] InterstitialPressureVolumeCoefs[Parts]={
          Physiolibrary.Blocks.Interpolation.SplineCoefficients(
            InterstitialPressureVolumeData[Parts.UpperTorso, :, 1]*1e-6,
            InterstitialPressureVolumeData[Parts.UpperTorso, :, 2]*(101325/760),
            InterstitialPressureVolumeData[Parts.UpperTorso, :, 3]*(101325/760)/1e-6),
          Physiolibrary.Blocks.Interpolation.SplineCoefficients(
            InterstitialPressureVolumeData[Parts.MiddleTorso, :, 1]*1e-6,
            InterstitialPressureVolumeData[Parts.MiddleTorso, :, 2]*(101325/760),
            InterstitialPressureVolumeData[Parts.MiddleTorso, :, 3]*(101325/760)/1e-6),
          Physiolibrary.Blocks.Interpolation.SplineCoefficients(
            InterstitialPressureVolumeData[Parts.LowerTorso, :, 1]*1e-6,
            InterstitialPressureVolumeData[Parts.LowerTorso, :, 2]*(101325/760),
            InterstitialPressureVolumeData[Parts.LowerTorso, :, 3]*(101325/760)/1e-6)};

    end Parameters;

    redeclare replaceable record extends State "Current state of anatomical division of the body"
       Physiolibrary.Types.Volume interstitialWater[Parts] "Volume of interstitial water";
    end State;

    redeclare replaceable function extends InterstitialPressure

        parameter Parts part "Part of the body";
        parameter Parameters params "Parameters of the anatomical division";

        input Physiolibrary.Types.Volume v "Volume of interstitial water";
        output Physiolibrary.Types.Pressure p "Interstitial hydraulic pressure";

    algorithm
        p := Physiolibrary.Blocks.Interpolation.Spline(
              params.InterstitialPressureVolumeData[part, :, 1]*1e-6,
              params.InterstitialPressureVolumeCoefs[part],
              v);
    end InterstitialPressure;


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
