# cal_adjust_PMIP

# (relative) paths to source files -- needs localization
prog = ../f90/main_programs/
mod = ../f90/modules/

# netCDF and OpenMP libraries -- needs localization
NCINC = -I$(HOME)/DATA/PaleoCalAdjust/netcdf/include
NCLIB = -L$(HOME)/DATA/PaleoCalAdjust/netcdf/lib 
LIBS = -lnetcdff -lnetcdf -lgomp

# compiler and flags
FC = gfortran 
FFLAGS = -O3 -Wall -Wl,-rpath,$(HOME)/.conda/envs/paleocaladjust/lib

# target, object and .mod files
target = cal_adjust_curated
objects = pseudo_daily_interp_subs.o calendar_effects_subs.o GISS_orbpar_subs.o \
    GISS_srevents_subs.o month_length_subs.o CMIP_netCDF_subs.o cal_adjust_curated.o
modules = pseudo_daily_interp_subs.mod calendar_effects_subs.mod GISS_orbpar_subs.mod \
    GISS_srevents_subs.mod month_length_subs.mod CMIP_netCDF_subs.mod

$(target): $(objects) 
	$(FC) $(FFLAGS) $(NCLIB) -o $(target) $(objects) $(LIBS)

pseudo_daily_interp_subs.o: $(mod)pseudo_daily_interp_subs.f90
	$(FC) $(FFLAGS) -c $(mod)pseudo_daily_interp_subs.f90

calendar_effects_subs.o: $(mod)calendar_effects_subs.f90
	$(FC) $(FFLAGS) -c $(mod)calendar_effects_subs.f90

GISS_orbpar_subs.o: $(mod)GISS_orbpar_subs.f90
	$(FC) $(FFLAGS) -c $(mod)GISS_orbpar_subs.f90

GISS_srevents_subs.o: $(mod)GISS_srevents_subs.f90
	$(FC) $(FFLAGS) -c $(mod)GISS_srevents_subs.f90

month_length_subs.o: $(mod)month_length_subs.f90
	$(FC) $(FFLAGS) -c $(mod)month_length_subs.f90

CMIP_netCDF_subs.o: $(mod)CMIP_netCDF_subs.f90 
	$(FC) $(FFLAGS) $(NCINC) -c $(mod)CMIP_netCDF_subs.f90 

cal_adjust_curated.o: $(prog)cal_adjust_curated.f90
	$(FC) $(FFLAGS) -fopenmp -c $(prog)cal_adjust_curated.f90

clean: 
	rm -f $(objects)
	rm -f $(modules)
 

clobber: clean
	rm -f $(target)
