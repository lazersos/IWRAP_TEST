
IMAS_INC = $(shell pkg-config imas-ifort --cflags) $(shell pkg-config xmllib --cflags)
IMAS_LIB = $(shell pkg-config imas-ifort --libs) $(shell pkg-config xmllib --libs)

.PHONY: libtest.a help

libtest.a :
	mpiifort -free -fPIC -O2 -fp-model strict -ip -assume noold_unit_star -axMIC-AVX512 -diag-disable=15009 -check noarg_temp_created $(IMAS_INC) -c test_imas.f90
	ar -cruv libtest.a test_imas.o

actor_test : libtest.a
	iwrap -f TEST_IMAS_ACTOR.yaml

xml_test : 
	@xmllint --noout indata.xsd indata.xml
	@xmllint --noout --schema indata.xsd indata.xml

help :
	@echo "Simplifies building various codes for IMAS"
	@echo "  libtest.a: Clean build of the library"
	@echo "  xml_test: Checks VMEC XML files"
	@echo "  actor_test: Builds TEST actor using iwrap"
