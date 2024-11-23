# make              # to compile files and create the executables
# make clean        # to cleanup object files and executables
# make cleanobj     # to cleanup object files only
# make pbm          # to download example images to the pbm/ dir
# make setup        # to setup the test files in pbmt/ dir
# make tests        # to run basic tests

CFLAGS = -Wall -Wextra -O2 -g

PROGS = imageBWTest imageBWTool

# Default rule: make all programs
all: $(PROGS)

imageBWTest: imageBWTest.o imageBW.o instrumentation.o

imageBWTest.o: imageBW.h instrumentation.h

imageBWTool: imageBWTool.o imageBW.o instrumentation.o

imageBWTool.o: imageBW.h instrumentation.h

# Rule to make any .o file dependent upon corresponding .h file
%.o: %.h

# Make uses builtin rule to create .o from .c files.

pbm:
	wget -O- https://sweet.ua.pt/jmr/aed/pbm.tgz | tar xzf -

pbmt/:
	wget -O- https://sweet.ua.pt/jmr/aed/pbmt.tgz | tar xzf -

.PHONY: setup
setup: $(PROGS) pbmt/

test1: setup	# neg (given)
	@echo "==== $@ ===="
	INSTRCTU=1 ./imageBWTool pbmt/chess9821.pbm raw neg raw save chess9820.pbm
	cmp chess9820.pbm pbmt/chess9820.pbm

test2: setup	# chess
	@echo "==== $@ ===="
	INSTRCTU=1 ./imageBWTool chess 9,8,3,0 raw rle save chess9830.pbm
	cmp chess9830.pbm pbmt/chess9830.pbm
	INSTRCTU=1 ./imageBWTool chess 9,8,2,1 raw rle save chess9821.pbm
	cmp chess9821.pbm pbmt/chess9821.pbm

test3: setup	# equal
	@echo "==== $@ ===="
	INSTRCTU=1 ./imageBWTool pbmt/chess9830.pbm pbmt/chess9830.pbm equal \
	| grep "ImageIsEqual(I0, I1) -> 1"
	INSTRCTU=1 ./imageBWTool pbmt/chess9830.pbm pbmt/chess9830x.pbm equal \
	| grep "ImageIsEqual(I0, I1) -> 0"

TESTS = test1 test2 test3 #test4 test5 test6 test7 test8 test9
.PHONY: tests
tests: $(TESTS)

cleanobj:
	rm -f *.o

clean: cleanobj
	rm -f $(PROGS)

