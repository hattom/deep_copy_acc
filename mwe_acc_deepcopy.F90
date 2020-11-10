program acc_deepcopy_test
  implicit none

  type numerical_f0
    real, dimension(:), allocatable     :: data1d
    real, dimension(:,:,:), allocatable :: data3d
    real                                :: dummy_scalar
    logical                             :: dummy_bool
    integer                             :: array_length
  end type numerical_f0

  type species_type
    logical            :: dummy_bool
    real               :: dummy_real
    type(numerical_f0) :: num_f0
  end type species_type

  type(species_type), allocatable, dimension(:) :: species
  !$acc declare create(species)

  integer :: nspecies


  ! test vars
  integer :: i, j, k


  nspecies = 3

  allocate(species(nspecies))
  species(2)%dummy_real = 3.0 !debug

  !$acc update device(species)

  do i=2,2
    print *, 'Host:', species(i)%dummy_real
  enddo

  !$acc parallel loop
  do i=2,2
    print *, 'Device:', species(i)%dummy_real
  enddo
  !$acc end parallel loop

  do i=1,nspecies
    if (i==3) then
      species(i)%num_f0%array_length = 50 !debug
      allocate(species(i)%num_f0%data1d(species(i)%num_f0%array_length))
      allocate(species(i)%num_f0%data3d( &
        species(i)%num_f0%array_length, &
        species(i)%num_f0%array_length, &
        species(i)%num_f0%array_length  &
      ))
      species(i)%num_f0%data1d(:) = 20.0 !debug
      species(i)%num_f0%data3d(:,:,:) = 10.0 !debug
    endif
  enddo

  do i=1,nspecies
    if (i==3) then
      !$acc update device(species(i)%num_f0)
    endif
  enddo

  !$acc parallel loop
  do i=3,3
    print *, 'Device vars:', species(i)%num_f0%dummy_scalar, &
    species(i)%num_f0%data1d(15), species(i)%num_f0%data3d(15,20,20)
  enddo
  !$acc end parallel loop
end program acc_deepcopy_test
