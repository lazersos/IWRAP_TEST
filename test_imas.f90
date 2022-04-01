!-----------------------------------------------------------------------
!     Module:        TEST_IMAS_MODULE
!     Authors:       S. Lazerson (samuel.lazerson@ipp.mpg.de)
!     Date:          09/22/2021
!     Description:   Provides IMAS interfaces for running VMEC from 
!                    IMAS.  Currently we assume the code runs
!                    standalone.
!-----------------------------------------------------------------------
MODULE TEST_IMAS_MODULE

CONTAINS   
!-----------------------------------------------------------------------
!     SUBROUTINE:        VMEC_IMAS_INIT
!     PURPOSE:           Handles Initialization of VMEC
!-----------------------------------------------------------------------
SUBROUTINE TEST_IMAS_INIT(INDATA_XML, status_code, status_message)
  !---------------------------------------------------------------------
  !     Libraries
  !---------------------------------------------------------------------
  USE ids_schemas

  !---------------------------------------------------------------------
  !     INPUT/OUTPUT VARIABLES
  !        INDATA_XML : VMEC INDATA namelist AS XML
  !        STATUS_CODE : STATUS Flag
  !        STATUS_MESSAGE : Text Message
  !---------------------------------------------------------------------
  IMPLICIT NONE
  TYPE(ids_parameters_input), INTENT(IN) :: INDATA_XML
  INTEGER, INTENT(OUT) :: status_code
  CHARACTER(LEN=:), POINTER, INTENT(OUT) :: status_message

  !---------------------------------------------------------------------
  !     BEGIN EXECUTION
  !---------------------------------------------------------------------

  status_code = 0
  !status_message = 'OK'

END SUBROUTINE TEST_IMAS_INIT

!-----------------------------------------------------------------------
!     SUBROUTINE:        TEST_IMAS
!     PURPOSE:           RUNS VMEC ASSUMING XML DEFINES RUN LIKE THE
!                        NAMELIST
!-----------------------------------------------------------------------
SUBROUTINE TEST_IMAS(IDS_EQ_IN, IDS_EQ_OUT, INDATA_XML, status_code, status_message)
  !---------------------------------------------------------------------
  !     Libraries
  !---------------------------------------------------------------------
  USE ids_schemas
  USE mpi

  !---------------------------------------------------------------------
  !     INPUT/OUTPUT VARIABLES
  !        IDS_EQ_OUT : Equilibrium output
  !        INDATA_XML : VMEC INDATA namelist AS XML
  !        STATUS_CODE : STATUS Flag
  !        STATUS_MESSAGE : Text Message
  !---------------------------------------------------------------------
  IMPLICIT NONE
  TYPE(ids_equilibrium), INTENT(IN) :: IDS_EQ_IN
  TYPE(ids_equilibrium), INTENT(OUT) :: IDS_EQ_OUT
  TYPE(ids_parameters_input), INTENT(IN) :: INDATA_XML
  INTEGER, INTENT(OUT) :: status_code
  CHARACTER(LEN=:), POINTER, INTENT(OUT) :: status_message

  !---------------------------------------------------------------------
  !     SUBROUTINE VARIABLES
  !---------------------------------------------------------------------
  LOGICAL :: lmpi_flag, lscreen
  INTEGER :: impi_flag, ivmec_flag, RVC_COMM, grank, gnranks
  INTEGER :: ictrl(5), myseq
  CHARACTER(len = 128)    :: reset_string, filename

  !---------------------------------------------------------------------
  !     BEGIN EXECUTION
  !---------------------------------------------------------------------

  !---- Default outputs
  status_code = 0
  !status_message = 'OK'

  !----  MPI initialisation ----
!  CALL MPI_initialized(lmpi_flag, impi_flag)
!  if (.not. lmpi_flag)   call MPI_INIT(impi_flag)

  !----  MIMIC CALL InitializeParallel
  CALL MPI_Comm_rank(MPI_COMM_WORLD,grank,impi_flag)
  CALL MPI_Comm_size(MPI_COMM_WORLD,gnranks,impi_flag)

  !----  Duplicate the communicator
  CALL MPI_COMM_DUP(MPI_COMM_WORLD,RVC_COMM,impi_flag)

  !----  Interface with Equilibirum IDS
  CALL TEST_EQIN_IMAS(IDS_EQ_IN,status_code,status_message)

  !----  Write out EQUILIBRIUM

  !---------------------------------------------------------------------
  !     END EXECUTION - Don't touch below here
  !---------------------------------------------------------------------

  !----  MPI Finalisation ----
!  call MPI_finalized(lmpi_flag, impi_flag)
!  IF (.NOT. lmpi_flag)   CALL MPI_Finalize(impi_flag)
  
END SUBROUTINE TEST_IMAS

!-----------------------------------------------------------------------
!     SUBROUTINE:        VMEC_EQIN_IMAS
!     PURPOSE:           Handles setting up the indata variables
!-----------------------------------------------------------------------
SUBROUTINE TEST_EQIN_IMAS(IDS_EQ_IN, status_code, status_message)
  !---------------------------------------------------------------------
  !     Libraries
  !---------------------------------------------------------------------
  USE ids_schemas

  !---------------------------------------------------------------------
  !     INPUT/OUTPUT VARIABLES
  !        INDATA_XML : VMEC INDATA namelist AS XML
  !        STATUS_CODE : STATUS Flag
  !        STATUS_MESSAGE : Text Message
  !---------------------------------------------------------------------
  IMPLICIT NONE
  TYPE(ids_equilibrium), INTENT(IN) :: IDS_EQ_IN
  INTEGER, INTENT(OUT) :: status_code
  CHARACTER(LEN=:), POINTER, INTENT(OUT) :: status_message

  !---------------------------------------------------------------------
  !     SUBROUTINE VARIABLES
  !---------------------------------------------------------------------
  INTEGER :: cocos_index, npts_imas, u, mn, itime
  REAL*8  :: B0
  REAL*8, ALLOCATABLE, DIMENSION(:) :: R_BND, Z_BND, radius, theta

  !---------------------------------------------------------------------
  !     BEGIN EXECUTION
  !---------------------------------------------------------------------
  status_code = 0
  itime = 1 ! This ia a hack

  !----  Check the IDS for timeslices
  IF (.not. ASSOCIATED(IDS_EQ_IN%time_slice)) THEN
     WRITE(*,*) 'No time slices in this equilibrium'
!     STOP
  END IF

  !----  Check Cocos Index
  !cocos_index = IDS_EQ_IN%time_slice(itime)%profiles_2d(1)%grid_type%index
  WRITE(*,*) ' IDS COCOS Convention: ',cocos_index


  RETURN
  

END SUBROUTINE TEST_EQIN_IMAS

END MODULE TEST_IMAS_MODULE
