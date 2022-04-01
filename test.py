import sys
import imas,os

from testact.actor import testact
from testact.common.runtime_settings import RunMode, DebugMode

input_entry = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND,'iter',131024,1,'public')
output_entry = imas.DBEntry(imas.imasdef.MDSPLUS_BACKEND,'test',131024,1,'g2slazer')
print('input_entry.open()')
input_entry.open()
print('output_entry.open()')
output_entry.open()

print('test_actor=test()')
test_actor=testact()

print('code_parameters = test_actor.get_code_parameters()')
code_parameters = test_actor.get_code_parameters()
code_parameters.parameters_path='./indata.xml'

print('runtime_settings = test_actor.get_runtime_settings()')
runtime_settings = test_actor.get_runtime_settings()
runtime_settings.run_mode = DebugMode.STANDALONE
runtime_settings.mpi.mpi_nodes = 1

print('test_actor.initialize(runtime_settings=runtime_settings, code_parameters=code_parameters)')
test_actor.initialize(runtime_settings=runtime_settings, code_parameters=code_parameters)

print('input_equilibrium = input_entry.get_slice(equilibrium,200.,1)')
input_equilibrium = input_entry.get_slice('equilibrium',200.,1)
#print('input_equilibrium = imas.equilibrium()')
#input_equilibrium = imas.equilibrium()

print('output_equilibrium = test_actor(input_equilibrium)')
output_equilibrium = test_actor(input_equilibrium)

print('test_actor.finalize()')
test_actor.finalize()
print('input_entry.close()')
input_entry.close()
print('output_entry.close()')
output_entry.close()
