!< FOODIE integrator: provide a predictor-corrector class of Adams-Bashforth-Moutlon multi-step schemes, from 1st to 4rd order
!< accurate.

module foodie_integrator_adams_bashforth_moulton
!< FOODIE integrator: provide a predictor-corrector class of Adams-Bashforth-Moutlon multi-step schemes, from 1st to 4rd order
!< accurate.
!<
!< Considering the following ODE system:
!<
!< $$ U_t = R(t,U) $$
!<
!< where \(U_t = \frac{dU}{dt}\), *U* is the vector of *state* variables being a function of the time-like independent variable
!< *t*, *R* is the (vectorial) residual function, the Adams-Bashforth-Moulton class scheme implemented is:
!<
!<##### predictor
!< $$ U^{n+N_s^p} = U^{n+N_s^p-1} +\Delta t \left[ \sum_{s=1}^{N_s^p}{ b_s^p \cdot R(t^{n+s-1}, U^{n+s-1}) } \right] $$
!<##### corrector
!< $$ U^{n+N_s^c} = U^{n+N_s^c-1} +\Delta t \left[ \sum_{s=0}^{N_s^c}{ b_s^c \cdot R(t^{n+s}, U^{n+s}) } \right] $$
!<
!<where \(N_s^p\) is the number of previous steps considered for the predictor and \(N_s^c\) is the number of previous steps
!<considered for the corrector.
!<
!< @note The value of \(\Delta t\) must be provided, it not being computed by the integrator.
!<
!< The coefficients \(b_s^{p,c}\) define the actual scheme, that is selected accordingly to the number of
!< **steps** used. The predictor and corrector schemes should have the same formal order of accuracy, thus \(N_s^p=N_s^c+1\)
!< should hold.
!<
!< Currently, the following schemes are available:
!<##### P=AB(1)-C=AM(0) step, Explicit/Implicit Farward/Backward Euler, 1st order
!< This scheme is TVD and reverts to Explicit/Implicit Farward/Backward Euler, it being 1st order.
!< The *b* coefficient is:
!< $$b^p = \left[b_1\right] = \left[1\right]$$
!< $$b^c = \left[b_0\right] = \left[1\right]$$
!< The scheme is:
!< $$ U^{n+1,p} = U^{n} + \Delta t R(t^{n},U^{n}) $$
!< $$ U^{n+1,c} = U^{n} + \Delta t R(t^{n+1},U^{n+1,p}) $$
!<
!<##### P=AB(2)-C=AM(1) steps
!< This scheme is 2nd order.
!< The *b* coefficients are:
!< $$b^p = \left[ {\begin{array}{*{20}{c}} b_1 & b_2 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} -\frac{1}{2} & \frac{3}{2} \end{array}} \right]$$
!< $$b^c = \left[ {\begin{array}{*{20}{c}} b_0 & b_1 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} \frac{1}{2} & \frac{1}{2} \end{array}} \right]$$
!< The scheme is:
!< $$ U^{n+2,p} = U^{n+1} +\Delta t \left[ \frac{3}{2} R(t^{n+1}, U^{n+1})-\frac{1}{2} R(t^{n}, U^{n})  \right] $$
!< $$ U^{n+2,c} = U^{n+1} +\Delta t \left[ \frac{1}{2} R(t^{n+2,p}, U^{n+2})+\frac{1}{2} R(t^{n+1}, U^{n+1}) \right] $$
!<
!<##### P=AB(3)-C=AM(2) steps
!< This scheme is 3rd order.
!< The *b* coefficients are:
!< $$b^p = \left[ {\begin{array}{*{20}{c}} b_1 & b_2 & b_3 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} \frac{5}{12} & -\frac{4}{3} & \frac{23}{12} \end{array}} \right]$$
!< $$b^c = \left[ {\begin{array}{*{20}{c}} b_0 & b_1 & b_2 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} -\frac{1}{12} & \frac{2}{3} & \frac{5}{12} \end{array}} \right]$$
!< The scheme is:
!< $$ U^{n+3,p} = U^{n+2} +\Delta t \left[ \frac{23}{12}R(t^{n+2}, U^{n+2}) - \frac{4}{3}R(t^{n+1}, U^{n+1})
!< +\frac{5}{12} R(t^{n}, U^{n})  \right] $$
!< $$ U^{n+3,c} = U^{n+2} +\Delta t \left[ \frac{5}{12}R(t^{n+3}, U^{n+3,p}) + \frac{2}{3}R(t^{n+2}, U^{n+2})
!< -\frac{1}{12} R(t^{n+1}, U^{n+1})  \right] $$
!<
!<##### P=AB(4)-C=AM(3) steps
!< This scheme is 4th order.
!< The *b* coefficients are:
!< $$b^p = \left[ {\begin{array}{*{20}{c}} b_1 & b_2 & b_3 & b_4 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} -\frac{9}{24} & \frac{37}{24} & -\frac{59}{24} & \frac{55}{24} \end{array}} \right]$$
!< $$b^c = \left[ {\begin{array}{*{20}{c}} b_0 & b_1 & b_2 & b_3 \end{array}} \right] =
!<         \left[ {\begin{array}{*{20}{c}} \frac{1}{24} & -\frac{5}{24} & \frac{19}{24} & \frac{9}{24} \end{array}} \right]$$
!< The scheme is:
!< $$ U^{n+4,p} = U^{n+3} +\Delta t \left[ \frac{55}{24}R(t^{n+3}, U^{n+3}) - \frac{59}{24}R(t^{n+2}, U^{n+2})
!< +\frac{37}{24} R(t^{n+1}, U^{n+1}) - \frac{9}{24} R(t^{n}, U^{n}) \right] $$
!< $$ U^{n+4,c} = U^{n+3} +\Delta t \left[ \frac{9}{24}R(t^{n+4}, U^{n+4,p}) + \frac{19}{24}R(t^{n+3}, U^{n+3})
!< -\frac{5}{24} R(t^{n+2}, U^{n+2}) + \frac{1}{24} R(t^{n+1}, U^{n+1}) \right] $$
!<
!<#### Bibliography
!<

use foodie_error_codes, only : ERROR_UNSUPPORTED_SCHEME
use foodie_integrand_object, only : integrand_object
use foodie_integrator_adams_bashforth, only : integrator_adams_bashforth
use foodie_integrator_adams_moulton, only : integrator_adams_moulton
use foodie_integrator_object, only : integrator_object
use penf, only : I_P, R_P

implicit none
private
public :: integrator_adams_bashforth_moulton

character(len=99), parameter :: class_name_='adams_bashforth_moulton'               !< Name of the class of schemes.
character(len=99), parameter :: supported_schemes_(1:16)=[trim(class_name_)//'_1 ', &
                                                          trim(class_name_)//'_2 ', &
                                                          trim(class_name_)//'_3 ', &
                                                          trim(class_name_)//'_4 ', &
                                                          trim(class_name_)//'_5 ', &
                                                          trim(class_name_)//'_6 ', &
                                                          trim(class_name_)//'_7 ', &
                                                          trim(class_name_)//'_8 ', &
                                                          trim(class_name_)//'_9 ', &
                                                          trim(class_name_)//'_10', &
                                                          trim(class_name_)//'_11', &
                                                          trim(class_name_)//'_12', &
                                                          trim(class_name_)//'_13', &
                                                          trim(class_name_)//'_14', &
                                                          trim(class_name_)//'_15', &
                                                          trim(class_name_)//'_16'] !< List of supported schemes.

logical, parameter :: has_fast_mode_=.true.  !< Flag to check if integrator provides *fast mode* integrate.
logical, parameter :: is_multistage_=.false. !< Flag to check if integrator is multistage.
logical, parameter :: is_multistep_=.true.   !< Flag to check if integrator is multistep.

type, extends(integrator_object) :: integrator_adams_bashforth_moulton
  !< FOODIE integrator: provide an explicit class of Adams-Bashforth-Moulton multi-step schemes, from 1st to 4rd order accurate.
  !<
  !< @note The integrator must be created or initialized (predictor and corrector schemes selection) before used.
  private
  integer(I_P)                     :: steps=0   !< Number of time steps.
  type(integrator_adams_bashforth) :: predictor !< Predictor solver.
  type(integrator_adams_moulton)   :: corrector !< Corrector solver.
  contains
    ! deferred methods
    procedure, pass(self) :: class_name           !< Return the class name of schemes.
    procedure, pass(self) :: description          !< Return pretty-printed object description.
    procedure, pass(self) :: has_fast_mode        !< Return .true. if the integrator class has *fast mode* integrate.
    procedure, pass(lhs)  :: integr_assign_integr !< Operator `=`.
    procedure, pass(self) :: is_multistage        !< Return .true. for multistage integrator.
    procedure, pass(self) :: is_multistep         !< Return .true. for multistep integrator.
    procedure, pass(self) :: is_supported         !< Return .true. if the integrator class support the given scheme.
    procedure, pass(self) :: stages_number        !< Return number of stages used.
    procedure, pass(self) :: steps_number         !< Return number of steps used.
    procedure, pass(self) :: supported_schemes    !< Return the list of supported schemes.
    ! public methods
    procedure, pass(self) :: destroy        !< Destroy the integrator.
    procedure, pass(self) :: initialize     !< Initialize (create) the integrator.
    procedure, pass(self) :: integrate      !< Integrate integrand field.
    procedure, pass(self) :: integrate_fast !< Integrate integrand field.
    procedure, pass(self) :: scheme_number  !< Return the scheme number in the list of supported schemes.
endtype integrator_adams_bashforth_moulton

contains
  ! deferred methods
  pure function class_name(self)
  !< Return the class name of schemes.
  class(integrator_adams_bashforth_moulton), intent(in) :: self       !< Integrator.
  character(len=99)                                     :: class_name !< Class name.

  class_name = trim(adjustl(class_name_))
  endfunction class_name

  pure function description(self, prefix) result(desc)
  !< Return a pretty-formatted object description.
  class(integrator_adams_bashforth_moulton), intent(in)           :: self             !< Integrator.
  character(*),                              intent(in), optional :: prefix           !< Prefixing string.
  character(len=:), allocatable                                   :: desc             !< Description.
  character(len=:), allocatable                                   :: prefix_          !< Prefixing string, local variable.
  character(len=1), parameter                                     :: NL=new_line('a') !< New line character.
  integer(I_P)                                                    :: s                !< Counter.

  prefix_ = '' ; if (present(prefix)) prefix_ = prefix
  desc = ''
  desc = desc//prefix_//'Adams-Bashforth-Moulton multi-step (predictor-corrector) schemes class'//NL
  desc = desc//prefix_//'  Supported schemes:'//NL
  do s=lbound(supported_schemes_, dim=1), ubound(supported_schemes_, dim=1) - 1
    desc = desc//prefix_//'    + '//supported_schemes_(s)//NL
  enddo
  desc = desc//prefix_//'    + '//supported_schemes_(ubound(supported_schemes_, dim=1))
  endfunction description

  elemental function has_fast_mode(self)
  !< Return .true. if the integrator class has *fast mode* integrate.
  class(integrator_adams_bashforth_moulton), intent(in) :: self          !< Integrator.
  logical                                               :: has_fast_mode !< Inquire result.

  has_fast_mode = has_fast_mode_
  endfunction has_fast_mode

  pure subroutine integr_assign_integr(lhs, rhs)
  !< Operator `=`.
  class(integrator_adams_bashforth_moulton), intent(inout) :: lhs !< Left hand side.
  class(integrator_object),                  intent(in)    :: rhs !< Right hand side.

  call lhs%assign_abstract(rhs=rhs)
  select type(rhs)
  class is (integrator_adams_bashforth_moulton)
    lhs%steps     = rhs%steps
    lhs%predictor = rhs%predictor
    lhs%corrector = rhs%corrector
  endselect
  endsubroutine integr_assign_integr

  elemental function is_multistage(self)
  !< Return .true. for multistage integrator.
  class(integrator_adams_bashforth_moulton), intent(in) :: self          !< Integrator.
  logical                                               :: is_multistage !< Inquire result.

  is_multistage = is_multistage_
  endfunction is_multistage

  elemental function is_multistep(self)
  !< Return .true. for multistage integrator.
  class(integrator_adams_bashforth_moulton), intent(in) :: self         !< Integrator.
  logical                                               :: is_multistep !< Inquire result.

  is_multistep = is_multistep_
  endfunction is_multistep

  elemental function is_supported(self, scheme)
  !< Return .true. if the integrator class support the given scheme.
  class(integrator_adams_bashforth_moulton), intent(in) :: self         !< Integrator.
  character(*),                              intent(in) :: scheme       !< Selected scheme.
  logical                                               :: is_supported !< Inquire result.
  integer(I_P)                                          :: s            !< Counter.

  is_supported = .false.
  do s=lbound(supported_schemes_, dim=1), ubound(supported_schemes_, dim=1)
    if (trim(adjustl(scheme)) == trim(adjustl(supported_schemes_(s)))) then
      is_supported = .true.
      return
    endif
  enddo
  endfunction is_supported

  elemental function stages_number(self)
  !< Return number of stages used.
  class(integrator_adams_bashforth_moulton), intent(in) :: self          !< Integrator.
  integer(I_P)                                          :: stages_number !< Number of stages used.

  stages_number = 0
  endfunction stages_number

  elemental function steps_number(self)
  !< Return number of steps used.
  class(integrator_adams_bashforth_moulton), intent(in) :: self         !< Integrator.
  integer(I_P)                                          :: steps_number !< Number of steps used.

  steps_number = self%steps
  endfunction steps_number

  pure function supported_schemes(self) result(schemes)
  !< Return the list of supported schemes.
  class(integrator_adams_bashforth_moulton), intent(in) :: self       !< Integrator.
  character(len=99), allocatable                        :: schemes(:) !< Queried scheme.

  allocate(schemes(lbound(supported_schemes_, dim=1):ubound(supported_schemes_, dim=1)))
  schemes = supported_schemes_
  endfunction supported_schemes

  ! public methods
  elemental subroutine destroy(self)
  !< Destroy the integrator.
  class(integrator_adams_bashforth_moulton), intent(inout) :: self !< Integrator.

  call self%destroy_abstract
  self%steps = 0
  call self%predictor%destroy
  call self%corrector%destroy
  endsubroutine destroy

  subroutine initialize(self, scheme)
  !< Create the actual Adams-Bashforth-Moulton integrator: initialize the *b* coefficients.
  class(integrator_adams_bashforth_moulton), intent(inout) :: self           !< Integrator.
  character(*),                              intent(in)    :: scheme         !< Selected scheme.
  character(len=99), allocatable                           :: schemes_ab(:)  !< Adams-Bashforth schemes.
  character(len=99), allocatable                           :: schemes_am(:)  !< Adams-Moulton schemes.
  integer(I_P)                                             :: scheme_number_ !< Scheme number in the list of supported schemes.

  if (self%is_supported(scheme=scheme)) then
    call self%destroy
    scheme_number_ = self%scheme_number(scheme=scheme)
    schemes_ab = self%predictor%supported_schemes()
    schemes_am = self%corrector%supported_schemes()
    call self%predictor%initialize(scheme=schemes_ab(scheme_number_))
    call self%corrector%initialize(scheme=schemes_am(scheme_number_))
    self%steps = self%predictor%steps_number()
  else
    call self%trigger_error(error=ERROR_UNSUPPORTED_SCHEME,                                   &
                            error_message='"'//trim(adjustl(scheme))//'" unsupported scheme', &
                            is_severe=.true.)
  endif
  endsubroutine initialize

  subroutine integrate(self, U, previous, Dt, t, iterations)
  !< Integrate field with Adams-Bashforth-Moulton class scheme.
  class(integrator_adams_bashforth_moulton), intent(in)           :: self         !< Integrator.
  class(integrand_object),                   intent(inout)        :: U            !< Field to be integrated.
  class(integrand_object),                   intent(inout)        :: previous(1:) !< Previous time steps solutions of integrand.
  real(R_P),                                 intent(in)           :: Dt           !< Time steps.
  real(R_P),                                 intent(in)           :: t(:)         !< Times.
  integer(I_P),                              intent(in), optional :: iterations   !< Fixed point iterations of AM scheme.

  call self%predictor%integrate(U=U, previous=previous, Dt=Dt, t=t, autoupdate=.false.)
  call self%corrector%integrate(U=U, previous=previous(2:), Dt=Dt, t=t, iterations=iterations, autoupdate=.false.)
  call self%predictor%update_previous(U=U, previous=previous)
  endsubroutine integrate

  subroutine integrate_fast(self, U, previous, buffer, Dt, t, iterations)
  !< Integrate field with Adams-Bashforth-Moulton class scheme, fast mode.
  class(integrator_adams_bashforth_moulton), intent(in)           :: self         !< Integrator.
  class(integrand_object),                   intent(inout)        :: U            !< Field to be integrated.
  class(integrand_object),                   intent(inout)        :: previous(1:) !< Previous time steps solutions of integrand.
  class(integrand_object),                   intent(inout)        :: buffer       !< Temporary buffer for doing fast operation.
  real(R_P),                                 intent(in)           :: Dt           !< Time steps.
  real(R_P),                                 intent(in)           :: t(:)         !< Times.
  integer(I_P),                              intent(in), optional :: iterations   !< Fixed point iterations of AM scheme.

  call self%predictor%integrate_fast(U=U, previous=previous, buffer=buffer, Dt=Dt, t=t, autoupdate=.false.)
  call self%corrector%integrate_fast(U=U, previous=previous(2:), buffer=buffer, Dt=Dt, t=t, iterations=iterations, &
                                     autoupdate=.false.)
  call self%predictor%update_previous(U=U, previous=previous)
  endsubroutine integrate_fast

  elemental function scheme_number(self, scheme)
  !< Return the scheme number in the list of supported schemes.
  class(integrator_adams_bashforth_moulton), intent(in) :: self          !< Integrator.
  character(*),                              intent(in) :: scheme        !< Selected scheme.
  integer(I_P)                                          :: scheme_number !< Scheme number in the list of supported schemes.
  integer(I_P)                                          :: s             !< Counter.

  scheme_number = 0
  do s=lbound(supported_schemes_, dim=1), ubound(supported_schemes_, dim=1)
    if (trim(adjustl(scheme)) == trim(adjustl(supported_schemes_(s)))) then
      scheme_number = s
      exit
    endif
  enddo
  endfunction scheme_number
endmodule foodie_integrator_adams_bashforth_moulton
