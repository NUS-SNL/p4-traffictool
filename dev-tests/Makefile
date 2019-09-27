include /usr/local/etc/PcapPlusPlus.mk

# All Target
all:
	g++ $(PCAPPP_BUILD_FLAGS) $(PCAPPP_INCLUDES) -c -o main.o test_pcpp.cpp
	g++ $(PCAPPP_LIBS_DIR) -static-libstdc++ -o Test-Pcap main.o $(PCAPPP_LIBS)

# Clean Target
clean:
	rm main.o
	rm Test-Pcap
