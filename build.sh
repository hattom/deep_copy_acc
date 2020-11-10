mpipgfortran -O2 -Mvect=simd -Munroll -Minline -Mlarge_arrays -Mcuda -acc -ta=tesla,cc70 -ta=tesla:lineinfo -Minfo=accel -r8 mwe_acc_deepcopy.F90 2> build.err
