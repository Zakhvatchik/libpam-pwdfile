PAM_LIB_DIR ?= $(DESTDIR)/lib/security
INSTALL ?= install
CFLAGS ?= -O2 -g -Wall -Wformat-security

CFLAGS += -fPIC -fvisibility=hidden
LDFLAGS += -Wl,-x -shared

TITLE = pam_pwdfile
LIBSHARED = $(TITLE).so
LDLIBS = -lcrypt -lpam
LIBOBJ = $(TITLE).o md5_good.o md5_broken.o md5_crypt_good.o md5_crypt_broken.o bigcrypt.o
CPPFLAGS_MD5_GOOD = -D'MD5Name(x)=Good\#\#x'
CPPFLAGS_MD5_BROKEN = -DHIGHFIRST -D'MD5Name(x)=Broken\#\#x'


all: $(LIBSHARED)

$(LIBSHARED): $(LIBOBJ)
	$(CC) $(LDFLAGS) $(LIBOBJ) $(LDLIBS) -o $@


md5_good.o: md5.c
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS_MD5_GOOD) $(CFLAGS) $< -o $@

md5_broken.o: md5.c
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS_MD5_BROKEN) $(CFLAGS) $< -o $@

md5_crypt_good.o: md5_crypt.c
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS_MD5_GOOD) $(CFLAGS) $< -o $@

md5_crypt_broken.o: md5_crypt.c
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS_MD5_BROKEN) $(CFLAGS) $< -o $@


install: $(LIBSHARED)
	$(INSTALL) -m 0755 -d $(PAM_LIB_DIR)
	$(INSTALL) -m 0755 $(LIBSHARED) $(PAM_LIB_DIR)

clean:
	$(RM) *.o *.so