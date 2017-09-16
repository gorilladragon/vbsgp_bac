% build matlab mex
mex CXXFLAGS="\$CXXFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" -output ../Main/VBAC_RVGPopenMP *.cpp -larmadillo -llapack -lblas