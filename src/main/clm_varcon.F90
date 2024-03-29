module clm_varcon

  !-----------------------------------------------------------------------
  ! !DESCRIPTION:
  ! Module containing various model constants.
  !
  ! !USES:
  use shr_kind_mod , only: r8 => shr_kind_r8
  use shr_const_mod, only: SHR_CONST_G,SHR_CONST_STEBOL,SHR_CONST_KARMAN,     &
                           SHR_CONST_RWV,SHR_CONST_RDAIR,SHR_CONST_CPFW,      &
                           SHR_CONST_CPICE,SHR_CONST_CPDAIR,SHR_CONST_LATVAP, &
                           SHR_CONST_LATSUB,SHR_CONST_LATICE,SHR_CONST_RHOFW, &
                           SHR_CONST_RHOICE,SHR_CONST_TKFRZ,SHR_CONST_REARTH, &
                           SHR_CONST_PDB, SHR_CONST_PI, SHR_CONST_CDAY,       &
                           SHR_CONST_RGAS, SHR_CONST_PSTD,                    &
                           SHR_CONST_MWDAIR, SHR_CONST_MWWV, SHR_CONST_CPFW
  use clm_varpar   , only: numrad, nlevgrnd, nlevlak, nlevdecomp_full
  use clm_varpar   , only: ngases
  use clm_varpar   , only: nlayer
  
  !
  ! !PUBLIC TYPES:
  implicit none
  save
  private
  !-----------------------------------------------------------------------
  !
  ! !PUBLIC MEMBER FUNCTIONS:
  public :: clm_varcon_init  ! initialize constants in clm_varcon
  public :: clm_varcon_clean ! deallocate variables allocated by clm_varcon_init
  !
  ! !REVISION HISTORY:
  ! Created by Mariana Vertenstein
  ! 27 February 2008: Keith Oleson; Add forcing height and aerodynamic parameters
  !-----------------------------------------------------------------------

  !------------------------------------------------------------------
  ! Initialize mathmatical constants
  !------------------------------------------------------------------

  real(r8), public :: rpi    = SHR_CONST_PI

  !------------------------------------------------------------------
  ! Initialize physical constants
  !------------------------------------------------------------------

  real(r8), public, parameter :: secsphr = 3600._r8                 ! Seconds in an hour
  integer,  public, parameter :: isecsphr = int(secsphr)            ! Integer seconds in an hour
  integer,  public, parameter :: isecspmin= 60                      ! Integer seconds in a minute
  real(r8), public :: grav   = SHR_CONST_G                          ! gravity constant [m/s2]
  real(r8), public :: sb     = SHR_CONST_STEBOL                     ! stefan-boltzmann constant  [W/m2/K4]
  real(r8), public :: vkc    = SHR_CONST_KARMAN                     ! von Karman constant [-]
  real(r8), public :: rwat   = SHR_CONST_RWV                        ! gas constant for water vapor [J/(kg K)]
  real(r8), public :: rair   = SHR_CONST_RDAIR                      ! gas constant for dry air [J/kg/K]
  real(r8), public :: roverg = SHR_CONST_RWV/SHR_CONST_G*1000._r8   ! Rw/g constant = (8.3144/0.018)/(9.80616)*1000. mm/K
  real(r8), public :: cpliq  = SHR_CONST_CPFW                       ! Specific heat of water [J/kg-K]
  real(r8), public :: cpice  = SHR_CONST_CPICE                      ! Specific heat of ice [J/kg-K]
  real(r8), public :: cpair  = SHR_CONST_CPDAIR                     ! specific heat of dry air [J/kg/K]
  real(r8), public :: hvap   = SHR_CONST_LATVAP                     ! Latent heat of evap for water [J/kg]
  real(r8), public :: hsub   = SHR_CONST_LATSUB                     ! Latent heat of sublimation    [J/kg]
  real(r8), public :: hfus   = SHR_CONST_LATICE                     ! Latent heat of fusion for ice [J/kg]
  real(r8), public :: denh2o = SHR_CONST_RHOFW                      ! density of liquid water [kg/m3]
  real(r8), public :: denice = SHR_CONST_RHOICE                     ! density of ice [kg/m3]
  real(r8), public :: rgas   = SHR_CONST_RGAS                       ! universal gas constant [J/K/kmole]
  real(r8), public :: pstd   = SHR_CONST_PSTD                       ! standard pressure [Pa]

  ! TODO(wjs, 2016-04-08) The following should be used in place of hard-coded constants
  ! of 0.622 and 0.378 (which is 1 - 0.622) in various places in the code:
  real(r8), public, parameter :: wv_to_dair_weight_ratio = SHR_CONST_MWWV/SHR_CONST_MWDAIR ! ratio of molecular weight of water vapor to that of dry air [-]

  real(r8), public :: tkair  = 0.023_r8                             ! thermal conductivity of air   [W/m/K]
  real(r8), public :: tkice  = 2.290_r8                             ! thermal conductivity of ice   [W/m/K]
  real(r8), public :: tkwat  = 0.57_r8                              ! thermal conductivity of water [W/m/K]
  real(r8), public, parameter :: tfrz   = SHR_CONST_TKFRZ           ! freezing temperature [K]
  real(r8), public, parameter :: tcrit  = 2.5_r8                    ! critical temperature to determine rain or snow
  real(r8), public :: o2_molar_const = 0.209_r8                     ! constant atmospheric O2 molar ratio (mol/mol)
  real(r8), public :: oneatm = 1.01325e5_r8                         ! one standard atmospheric pressure [Pa]
  real(r8), public :: bdsno = 250._r8                               ! bulk density snow (kg/m**3)
  real(r8), public :: alpha_aero = 1.0_r8                           ! constant for aerodynamic parameter weighting
  real(r8), public :: tlsai_crit = 2.0_r8                           ! critical value of elai+esai for which aerodynamic parameters are maximum
  real(r8), public :: watmin = 0.01_r8                              ! minimum soil moisture (mm)
  real(r8), public :: c_water = SHR_CONST_CPFW                      ! specific heat of water   [J/kg/K]
  real(r8), public :: c_dry_biomass  = 1400_r8                      ! specific heat of dry biomass

  real(r8), public :: re = SHR_CONST_REARTH*0.001_r8                ! radius of earth (km)

  real(r8), public, parameter :: degpsec = 15._r8/3600.0_r8 ! Degree's earth rotates per second
  real(r8), public, parameter :: secspday= SHR_CONST_CDAY   ! Seconds per day
  integer,  public, parameter :: isecspday= secspday        ! Integer seconds per day

  integer, public, parameter  :: fun_period  = 1            ! A FUN parameter, and probably needs to be changed for testing
  real(r8),public, parameter  :: smallValue  = 1.e-12_r8    ! A small values used by FUN
  real(r8),public, parameter  :: sum_to_1_tol = 1.e-13_r8   ! error tolerance 

  ! ------------------------------------------------------------------------
  ! Special value flags
  ! ------------------------------------------------------------------------

  ! NOTE(wjs, 2015-11-23) The presence / absence of spval should be static in time for
  ! multi-level fields.  i.e., if a given level & column has spval at initialization, it
  ! should remain spval throughout the run (e.g., indicating that this level is not valid
  ! for this column type); similarly, if it starts as a valid value, it should never
  ! become spval. This is needed for init_interp to work correctly on multi-level fields.
  ! For more details, see the note near the top of initInterpMultilevelInterp.
  real(r8), public, parameter ::  spval = 1.e36_r8          ! special value for real data

  ! Keep this negative to avoid conflicts with possible valid values
  integer , public, parameter :: ispval = -9999             ! special value for int data

  ! ------------------------------------------------------------------------
  ! These are tunable constants from clm2_3
  ! ------------------------------------------------------------------------

  real(r8), public :: capr   = 0.34_r8      ! Tuning factor to turn first layer T into surface T
  real(r8), public :: cnfac  = 0.5_r8       ! Crank Nicholson factor between 0 and 1
  real(r8), public :: pondmx = 0.0_r8       ! Ponding depth (mm)
  real(r8), public :: pondmx_urban = 1.0_r8 ! Ponding depth for urban roof and impervious road (mm)

  real(r8), public :: thk_bedrock = 3.0_r8  ! thermal conductivity of 'typical' saturated granitic rock 
                                    ! (Clauser and Huenges, 1995)(W/m/K)
  real(r8), public :: csol_bedrock = 2.0e6_r8 ! vol. heat capacity of granite/sandstone  J/(m3 K)(Shabbir, 2000)
  real(r8), public, parameter :: zmin_bedrock = 0.4_r8 ! minimum soil depth [m]

  real(r8), public, parameter :: aquifer_water_baseline = 5000._r8 ! baseline value for water in the unconfined aquifer [mm]
  real(r8), public, parameter :: c_to_b = 2.0_r8         ! conversion between mass carbon and total biomass (g biomass /g C)
  ! Some non-tunable conversions (may need to place elsewhere)
  real(r8), public, parameter :: g_to_mg = 1.0e3_r8  ! coefficient to convert g to mg
  real(r8), public, parameter :: cm3_to_m3 = 1.0e-6_r8  ! coefficient to convert cm3 to m3
  real(r8), public, parameter :: pct_to_frac = 1.0e-2_r8  ! coefficient to convert % to fraction
  
  !!! C13
  real(r8), public, parameter :: preind_atm_del13c = -6.0_r8   ! preindustrial value for atmospheric del13C
  real(r8), public, parameter :: preind_atm_ratio = SHR_CONST_PDB + (preind_atm_del13c * SHR_CONST_PDB)/1000.0_r8  ! 13C/12C
  real(r8), public :: c13ratio = preind_atm_ratio/(1.0_r8+preind_atm_ratio) ! 13C/(12+13)C preind atmosphere

   ! typical del13C for C3 photosynthesis (permil, relative to PDB)
  real(r8), public, parameter :: c3_del13c = -28._r8

  ! typical del13C for C4 photosynthesis (permil, relative to PDB)
  real(r8), public, parameter :: c4_del13c = -13._r8

  ! isotope ratio (13c/12c) for C3 photosynthesis
  real(r8), public, parameter :: c3_r1 = SHR_CONST_PDB + ((c3_del13c*SHR_CONST_PDB)/1000._r8)

  ! isotope ratio (13c/[12c+13c]) for C3 photosynthesis
  real(r8), public, parameter :: c3_r2 = c3_r1/(1._r8 + c3_r1)

  ! isotope ratio (13c/12c) for C4 photosynthesis  
  real(r8), public, parameter :: c4_r1 = SHR_CONST_PDB + ((c4_del13c*SHR_CONST_PDB)/1000._r8)

  ! isotope ratio (13c/[12c+13c]) for C4 photosynthesis
  real(r8), public, parameter :: c4_r2 = c4_r1/(1._r8 + c4_r1)

  !!! C14
  real(r8), public :: c14ratio = 1.e-12_r8
  ! real(r8) :: c14ratio = 1._r8  ! debug lets set to 1 to try to avoid numerical errors

  !------------------------------------------------------------------
  ! Surface roughness constants
  !------------------------------------------------------------------
  real(r8), public, parameter :: beta_param = 7.2_r8  ! Meier et al. (2022) https://doi.org/10.5194/gmd-15-2365-2022
  real(r8), public, parameter :: nu_param = 1.5e-5_r8  ! Meier et al. (2022) kinematic viscosity of air
  real(r8), public, parameter :: b1_param = 1.4_r8  ! Meier et al. (2022) empirical constant
  real(r8), public, parameter :: b4_param = -0.31_r8  ! Meier et al. (2022) empirical constant
  real(r8), public, parameter :: cd1_param = 7.5_r8  ! Meier et al. (2022) originally from Raupach (1994)
  real(r8), public, parameter :: meier_param1 = 0.23_r8  ! slevis did not find it documented
  real(r8), public, parameter :: meier_param2 = 0.08_r8  ! slevis did not find it documented
  real(r8), public, parameter :: meier_param3 = 70.0_r8  ! slevis did not find it documented, but to the question "What is the 70 in the formula for roughness length" bard.google.com responds "[...] a dimensionless constant [...] originally introduced by von Karman. It is based on experimental data and is thought to represent the ratio of the average height of the surface roughness elements to the distance that the wind travels before it is slowed down by the roughness."

  !------------------------------------------------------------------
  ! Urban building temperature constants
  !------------------------------------------------------------------
  real(r8), public :: ht_wasteheat_factor = 0.2_r8   ! wasteheat factor for urban heating (-)
  real(r8), public :: ac_wasteheat_factor = 0.6_r8   ! wasteheat factor for urban air conditioning (-)
  real(r8), public :: em_roof_int  = 0.9_r8          ! emissivity of interior surface of roof (Bueno et al. 2012, GMD)
  real(r8), public :: em_sunw_int  = 0.9_r8          ! emissivity of interior surface of sunwall (Bueno et al. 2012, GMD)
  real(r8), public :: em_shdw_int  = 0.9_r8          ! emissivity of interior surface of shadewall Bueno et al. 2012, GMD)
  real(r8), public :: em_floor_int = 0.9_r8          ! emissivity of interior surface of floor (Bueno et al. 2012, GMD)
  real(r8), public :: hcv_roof = 0.948_r8            ! interior convective heat transfer coefficient for roof (Bueno et al. 2012, GMD) (W m-2 K-1)
  real(r8), public :: hcv_roof_enhanced  = 4.040_r8  ! enhanced (t_roof_int <= t_room) interior convective heat transfer coefficient for roof (Bueno et al. 2012, GMD) !(W m-2 K-1)
  real(r8), public :: hcv_floor = 0.948_r8           ! interior convective heat transfer coefficient for floor (Bueno et al. 2012, GMD) (W m-2 K-1)
  real(r8), public :: hcv_floor_enhanced  = 4.040_r8 ! enhanced (t_floor_int >= t_room) interior convective heat transfer coefficient for floor (Bueno et al.  !2012, GMD) (W m-2 K-1)
  real(r8), public :: hcv_sunw  = 3.076_r8           ! interior convective heat transfer coefficient for sunwall (Bueno et al. 2012, GMD) (W m-2 K-1)
  real(r8), public :: hcv_shdw  = 3.076_r8           ! interior convective heat transfer coefficient for shadewall (Bueno et al. 2012, GMD) (W m-2 K-1)
  real(r8), public :: dz_floor = 0.1_r8                 ! floor thickness - concrete (Salmanca et al. 2010, TAC) (m)
  real(r8), public, parameter :: dens_floor = 2.35e3_r8 ! density of floor - concrete (Salmanca et al. 2010, TAC) (kg m-3)
  real(r8), public, parameter :: sh_floor = 880._r8     ! specific heat of floor - concrete (Salmanca et al. 2010, TAC) (J kg-1 K-1)
  real(r8), public :: cp_floor = dens_floor*sh_floor    ! volumetric heat capacity of floor - concrete (Salmanca et al. 2010, TAC) (J m-3 K-1)
  real(r8), public :: vent_ach = 0.3_r8                    ! ventilation rate (air exchanges per hour)

  real(r8), public :: wasteheat_limit = 100._r8         ! limit on wasteheat (W/m2)

  !------------------------------------------------------------------

  real(r8), public :: h2osno_max   = -999.0_r8            ! max allowed snow thickness (mm H2O)

  integer, private :: i  ! loop index

 !real(r8), parameter :: nitrif_n2o_loss_frac = 0.02_r8  ! fraction of N lost as N2O in nitrification (Parton et al., 2001)
  real(r8), public, parameter :: nitrif_n2o_loss_frac = 6.e-4_r8 ! fraction of N lost as N2O in nitrification (Li et al., 2000)
  real(r8), public, parameter :: frac_minrlztn_to_no3 = 0.2_r8   ! fraction of N mineralized that is dieverted to the nitrification stream (Parton et al., 2001)

  !------------------------------------------------------------------
  ! Set subgrid names
  !------------------------------------------------------------------

  character(len=16), public, parameter :: grlnd  = 'lndgrid'      ! name of lndgrid
  character(len=16), public, parameter :: nameg  = 'gridcell'     ! name of gridcells
  character(len=16), public, parameter :: namel  = 'landunit'     ! name of landunits
  character(len=16), public, parameter :: namec  = 'column'       ! name of columns
  character(len=16), public, parameter :: namep  = 'pft'          ! name of patches
  character(len=16), public, parameter :: nameCohort = 'cohort'   ! name of cohorts (ED specific)

  !------------------------------------------------------------------
  ! Initialize miscellaneous radiation constants
  !------------------------------------------------------------------

  real(r8), public :: betads  = 0.5_r8            ! two-stream parameter betad for snow
  real(r8), public :: betais  = 0.5_r8            ! two-stream parameter betai for snow
  real(r8), public :: omegas(numrad)           ! two-stream parameter omega for snow by band
  data (omegas(i),i=1,numrad) /0.8_r8, 0.4_r8/

  ! Lake Model Constants will be defined in LakeCon.

  !------------------------------------------------------------------
  ! Soil depths are constants for now; lake depths can vary by gridcell
  ! zlak and dzlak correspond to the default 50 m lake depth.
  ! The values for the following arrays are set in routine iniTimeConst
  !------------------------------------------------------------------

  real(r8), public, allocatable :: zlak(:)         !lake z  (layers)
  real(r8), public, allocatable :: dzlak(:)        !lake dz (thickness)
  real(r8), public, allocatable :: zsoi(:)         !soil z  (layers)
  real(r8), public, allocatable :: dzsoi(:)        !soil dz (thickness)
  real(r8), public, allocatable :: zisoi(:)        !soil zi (interfaces)
  real(r8), public, allocatable :: dzsoi_decomp(:) !soil dz (thickness)
  integer , public, allocatable :: nlvic(:)        !number of CLM layers in each VIC layer (#)
  real(r8), public, allocatable :: dzvic(:)        !soil dz (thickness) of each VIC layer

  !------------------------------------------------------------------
  ! (Non-tunable) Constants for the CH4 submodel (Tuneable constants in ch4varcon)
  !------------------------------------------------------------------
  ! Note some of these constants are also used in CNNitrifDenitrifMod

  real(r8), public, parameter :: catomw = 12.011_r8 ! molar mass of C atoms (g/mol)

  real(r8), public :: s_con(ngases,4)    ! Schmidt # calculation constants (spp, #)
  data (s_con(1,i),i=1,4) /1898_r8, -110.1_r8, 2.834_r8, -0.02791_r8/ ! CH4
  data (s_con(2,i),i=1,4) /1801_r8, -120.1_r8, 3.7818_r8, -0.047608_r8/ ! O2
  data (s_con(3,i),i=1,4) /1911_r8, -113.7_r8, 2.967_r8, -0.02943_r8/ ! CO2

  real(r8), public :: d_con_w(ngases,3)    ! water diffusivity constants (spp, #)  (mult. by 10^-4)
  data (d_con_w(1,i),i=1,3) /0.9798_r8, 0.02986_r8, 0.0004381_r8/ ! CH4
  data (d_con_w(2,i),i=1,3) /1.172_r8, 0.03443_r8, 0.0005048_r8/ ! O2
  data (d_con_w(3,i),i=1,3) /0.939_r8, 0.02671_r8, 0.0004095_r8/ ! CO2

  real(r8), public :: d_con_g(ngases,2)    ! gas diffusivity constants (spp, #) (cm^2/s) (mult. by 10^-9)
  data (d_con_g(1,i),i=1,2) /0.1875_r8, 0.0013_r8/ ! CH4
  data (d_con_g(2,i),i=1,2) /0.1759_r8, 0.00117_r8/ ! O2
  data (d_con_g(3,i),i=1,2) /0.1325_r8, 0.0009_r8/ ! CO2

  real(r8), public :: c_h_inv(ngases)    ! constant (K) for Henry's law (4.12, Wania)
  data c_h_inv(1:3) /1600._r8, 1500._r8, 2400._r8/ ! CH4, O2, CO2

  real(r8), public :: kh_theta(ngases)    ! Henry's constant (L.atm/mol) at standard temperature (298K)
  data kh_theta(1:3) /714.29_r8, 769.23_r8, 29.4_r8/ ! CH4, O2, CO2

  real(r8), public :: kh_tbase = 298._r8 ! base temperature for calculation of Henry's constant (K)
  !-----------------------------------------------------------------------

contains

  !------------------------------------------------------------------------------
  subroutine clm_varcon_init( is_simple_buildtemp )
    !
    ! !DESCRIPTION:
    ! This subroutine initializes constant arrays in clm_varcon. 
    ! MUST be called  after clm_varpar_init.
    !
    ! !USES:
    use clm_varpar, only: nlevgrnd, nlevlak, nlevdecomp_full, nlayer
    !
    ! !ARGUMENTS:
    implicit none
    logical, intent(in) :: is_simple_buildtemp   ! If simple building temp method is being used
    !
    ! !REVISION HISTORY:
    !   Created by E. Kluzek
!------------------------------------------------------------------------------

    allocate( zlak(1:nlevlak                 ))
    allocate( dzlak(1:nlevlak                ))
    allocate( zsoi(1:nlevgrnd                ))
    allocate( dzsoi(1:nlevgrnd               ))
    allocate( zisoi(0:nlevgrnd               ))
    allocate( dzsoi_decomp(1:nlevdecomp_full ))
    allocate( nlvic(1:nlayer                 ))
    allocate( dzvic(1:nlayer                 ))

    ! Zero out wastheat factors for simpler building temperature method (introduced in CLM4.5)
    if ( is_simple_buildtemp )then
        ht_wasteheat_factor = 0.0_r8
        ac_wasteheat_factor = 0.0_r8
    end if

  end subroutine clm_varcon_init

  !-----------------------------------------------------------------------
  subroutine clm_varcon_clean()
    !
    ! !DESCRIPTION:
    ! Deallocate variables allocated by clm_varcon_init
    !
    ! !LOCAL VARIABLES:

    character(len=*), parameter :: subname = 'clm_varcon_clean'
    !-----------------------------------------------------------------------

    deallocate(zlak)
    deallocate(dzlak)
    deallocate(zsoi)
    deallocate(dzsoi)
    deallocate(zisoi)
    deallocate(dzsoi_decomp)
    deallocate(nlvic)
    deallocate(dzvic)

  end subroutine clm_varcon_clean


end module clm_varcon
