program doscar_analysis

implicit none

integer :: number_of_atoms ! total number of atoms in POSCAR
integer :: i ! dummy
double precision :: t ! dummy
double precision :: Emax , Emin ! max and min value of the energy (absciss limits)
integer :: number_of_steps ! discretization of the abscissa
double precision :: Efermi ! Fermi energy of the system
integer :: choice ! choice made by user
integer :: choice_translate ! choice made by user : translate or not to fermi energy
integer :: choice_polarization ! choice made by user : polarization enabled or not
integer :: choice_atom ! choice made by user : label of the atom the user wants the PDOS of
double precision :: dos_up , dos_down ! local value of dos spin up and spin down
double precision :: n1 , n2 , n3 , n4 , n5 , n6 , n7 , n8 , n9 , n10 , n11 , n12 , n13 , n14 , n15 , n16 , n17 , n18
 
! open DOSCAR
open ( 10 , file = 'DOSCAR' , form = 'formatted' )
 
! first line is the total number of atoms and 3 numbers i don't know what they mean
read ( 10 , * ) number_of_atoms , i , i , i
 
! line 2 to 5 are useless
do i = 2 , 5 ; read ( 10 , * ) ; end do
 
! line 6 contains Emax , Emin , number_of_steps , Efermi and ?
read ( 10 , * ) Emax , Emin , number_of_steps , Efermi , t
 
! ask user what he wants of me
77 write ( * , * ) "Do you want to compute the total density of states (press 1) or a projected one (press 2) ?"
read ( * , * ) choice
 
! test if answer is correct
if ( choice /= 1 .and. choice /= 2 ) then
  write ( * , * ) "Only 1 or 2 is possible."
  goto 77
end if
 
! ask user if he wants to translate to Fermi level or not
88 write ( * , * ) "Do you want to translate all the energies to Fermi energy (press 1 for yes , press 2 for no) ?"
read ( * , * ) choice_translate
 
! test if answer is correct
if ( choice_translate /= 1 .and. choice_translate /= 2 ) then
  write ( * , * ) "Only 1 or 2 is possible."
  goto 88
end if
 
! ask user if the calculation is polarized or not
99 write ( * , * ) "Is system polarized (press 1 for yes , press 2 for no) ?"
read ( * , * ) choice_polarization
 
! test if answer is correct
if ( choice_polarization /= 1 .and. choice_polarization /= 2 ) then
  write ( * , * ) "Only 1 or 2 is possible."
  goto 99
end if
 
! open file for writting output
open ( unit = 11 , file = 'doscar_analysis.out' , form = 'formatted' )
 
! write it Fermi energy
write ( 11 , * ) "# E fermi = " , Efermi
 
! if total DOS is wanted
if ( choice == 1 ) then
 
  ! read the number_of_steps next lines.
  if ( choice_polarization == 1 ) then
    do i = 1 , number_of_steps
      read ( 10 , * ) t , dos_up , dos_down
      if ( choice_translate == 1 ) write ( 11 , * ) t - Efermi , dos_up , dos_down , dos_up + dos_down
      if ( choice_translate == 2 ) write ( 11 , * ) t , dos_up , dos_down , dos_up + dos_down
    end do
  else if ( choice_polarization == 2 ) then
    do i = 1 , number_of_steps
      read ( 10 , * ) t , dos_up
      if ( choice_translate == 1 ) write ( 11 , * ) t - Efermi , dos_up
      if ( choice_translate == 2 ) write ( 11 , * ) t , dos_up
    end do
  end if
else if ( choice == 2 ) then
  ! if projected DOS is wanted
  ! first ask user which atom he is interested in
  1010 write ( * , * ) "Which atom (same label as in POSCAR and first label is 1 (not 0)) ?"
  read ( * , * ) choice_atom

  ! test if answer is correct
  if ( choice_atom < 1 .or. choice_atom > number_of_atoms ) then
    write ( * , * ) "Wrong answer"
    goto 1010
  end if

  ! go to line corresponding to good label
  ! ignore first total dos lines
  do i = 1 , number_of_steps ; read ( 10 , * ) ; end do
  ! ignore non wanted atoms
  if ( choice_atom > 1 ) then
    do i = 1 , ( choice_atom - 1) * ( number_of_steps + 1 ) ; read ( 10 , * ) ; end do
  end if
 
  ! read useless line
  read ( 10 , * )

  ! read info. format is s+ s- px+ px- py+ py- pz+ pz- dxy+ dxy- dyz+ dyz- dxz+ dxz- dx2-y2+ dx2-y2- dz2+ dz2-
  ! or s px py pz dxy dyz dxz dx2-y2 dz2
  do i = 1 , number_of_steps
    if ( choice_polarization == 1 ) then
      read ( 10 , * ) t , n1 , n2 , n3 , n4 , n5 , n6 , n7 , n8 , n9 , n10 , n11 , n12 , n13 , n14 , n15 , n16 , n17 , n18
      dos_up = n1 + n3 + n5 + n7 + n9 + n11 + n13 + n15 + n17
      dos_down = n2 + n4 + n6 + n8 + n10 + n12 + n14 + n16 + n18
      if ( choice_translate == 1 ) write ( 11 , * ) t - Efermi , dos_up , dos_down , dos_up + dos_down
      if ( choice_translate == 2 ) write ( 11 , * ) t , dos_up , dos_down , dos_up + dos_down
    else if ( choice_polarization == 2 ) then
      read ( 10 , * ) t , n1 , n2 , n3 , n4 , n5 , n6 , n7 , n8 , n9
      dos_up = n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9
      if ( choice_translate == 1 ) write ( 11 , * ) t - Efermi , dos_up
      if ( choice_translate == 2 ) write ( 11 , * ) t , dos_up
    end if
  end do
end if
 
! close DOSCAR
close ( 10 )
 
! close output file doscar_analysis.out
close ( 11 )

! OK to user
write ( * , * ) 'done. look at    doscar_analysis.out'
write ( * , * ) 'To read it, you may use      xmgrace -nxy doscar_analysis.out'
 
end program doscar_analysis
