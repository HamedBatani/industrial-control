clear
clc
close all

s = tf('s');

% continuous systems
g = 5 + 12/(s+1);
h = 8*(s+3)/(s^2 + 10*s + 29);

% sampling times
tg = 0.089;
th = 0.02;

w0 = 5;

% discretization
g_pz = c2d(g,tg,'matched');
g_tu = c2d(g,tg,'tustin');
g_bw = c2d(g,tg,'tustin',w0);

h_pz = c2d(h,th,'matched');
h_tu = c2d(h,th,'tustin');
h_bw = c2d(h,th,'tustin',w0);

% frequency grid
w = logspace(-2,2,1000);

% bode data
[mg,pg] = bode(g,w);
[mg_pz,pg_pz] = bode(g_pz,w);
[mg_tu,pg_tu] = bode(g_tu,w);
[mg_bw,pg_bw] = bode(g_bw,w);

[mh,ph] = bode(h,w);
[mh_pz,ph_pz] = bode(h_pz,w);
[mh_tu,ph_tu] = bode(h_tu,w);
[mh_bw,ph_bw] = bode(h_bw,w);

mg=squeeze(mg); pg=squeeze(pg);
mg_pz=squeeze(mg_pz); pg_pz=squeeze(pg_pz);
mg_tu=squeeze(mg_tu); pg_tu=squeeze(pg_tu);
mg_bw=squeeze(mg_bw); pg_bw=squeeze(pg_bw) ;

mh=squeeze(mh); ph=squeeze(ph);
mh_pz=squeeze(mh_pz); ph_pz=squeeze(ph_pz);
mh_tu=squeeze(mh_tu); ph_tu=squeeze(ph_tu) ;
mh_bw=squeeze(mh_bw); ph_bw=squeeze(ph_bw);

% colors
c1 = [0 0.7 1] ;
c2 = [1 0.3 0.3];
c3 = [0.3 0.9 0.3];
c4 = [0.7 0.4 1] ;

figure('color','w')

% magnitude g
subplot(2,2 ,1)
semilogx(w,20*log10(mg), 'color',c1,'linewidth',3)
hold on
semilogx(w,20*log10(mg_pz), '--','color',c2,'linewidth',2)
semilogx(w,20*log10(mg_tu),'-.','color',c3,'linewidth',2 ) 
semilogx(w,20*log10(mg_bw),':','color', c4,'linewidth' ,3)
grid on
title('g(s) magnitude' )
xlabel('\omega  rad/s' )
ylabel('db')
legend('ct','pz', 'tustin','prewarp')

% phase g
subplot(2,2,2)
semilogx(w,pg, 'color',c1,'linewidth',3)
hold on
semilogx(w,pg_pz,'--','color',c2,'linewidth',2)
semilogx(w,pg_tu,'-.','color',c3,'linewidth',2)
semilogx(w,pg_bw,':','color' ,c4, 'linewidth',3)
grid on
title('g(s) phase ')
xlabel('\omega rad/s')
ylabel('deg')

% magnitude h
subplot(2,2,3)
semilogx(w,20*log10(mh),'color',c1,'linewidth',3)
hold on
semilogx(w,20*log10(mh_pz),'--','color',c2,'linewidth',2)
semilogx(w,20*log10(mh_tu),'-.','color',c3,'linewidth',2)
semilogx(w,20*log10(mh_bw),':','color',c4,'linewidth',3)
grid on
title('h(s) magnitude')
xlabel('\omega rad/s')
ylabel('db')
legend('ct','pz','tustin','prewarp')

% phase h
subplot(2,2,4)
semilogx(w,ph,'color',c1,'linewidth' ,3 )
hold on
semilogx(w,ph_pz,'--','color',c2,'linewidth',2)
semilogx(w,ph_tu,'-.','color',c3,'linewidth',2 )
semilogx(w,ph_bw,':','color',c4,'linewidth',3)
grid on
title('h(s) phase')
xlabel('\omega  rad/s ')
ylabel('deg' )
clear
clc
close all

s = tf('s');

% continuous systems
g = 5 + 12/(s+1);
h = 8*(s+3)/(s^2 + 10*s + 29);

% sampling times
tg = 0.089;
th = 0.02;

w0 = 5;

% discretization
g_pz = c2d(g,tg,'matched');
g_tu = c2d(g,tg,'tustin');
g_bw = c2d(g,tg,'tustin',w0);

h_pz = c2d(h,th,'matched');
h_tu = c2d(h,th,'tustin');
h_bw = c2d(h,th,'tustin',w0);

% frequency grid
w = logspace(-2,2,1000);

% bode data
[mg,pg] = bode(g,w);
[mg_pz,pg_pz] = bode(g_pz,w);
[mg_tu,pg_tu] = bode(g_tu,w);
[mg_bw,pg_bw] = bode(g_bw,w);

[mh,ph] = bode(h,w);
[mh_pz,ph_pz] = bode(h_pz,w);
[mh_tu,ph_tu] = bode(h_tu,w);
[mh_bw,ph_bw] = bode(h_bw,w);

mg=squeeze(mg); pg=squeeze(pg);
mg_pz=squeeze(mg_pz); pg_pz=squeeze(pg_pz);
mg_tu=squeeze(mg_tu); pg_tu=squeeze(pg_tu);
mg_bw=squeeze(mg_bw); pg_bw=squeeze(pg_bw) ;

mh=squeeze(mh); ph=squeeze(ph);
mh_pz=squeeze(mh_pz); ph_pz=squeeze(ph_pz);
mh_tu=squeeze(mh_tu); ph_tu=squeeze(ph_tu) ;
mh_bw=squeeze(mh_bw); ph_bw=squeeze(ph_bw);

% colors
c1 = [0 0.7 1] ;
c2 = [1 0.3 0.3];
c3 = [0.3 0.9 0.3];
c4 = [0.7 0.4 1] ;

figure('color','w')

% magnitude g
subplot(2,2 ,1)
semilogx(w,20*log10(mg), 'color',c1,'linewidth',3)
hold on
semilogx(w,20*log10(mg_pz), '--','color',c2,'linewidth',2)
semilogx(w,20*log10(mg_tu),'-.','color',c3,'linewidth',2 ) 
semilogx(w,20*log10(mg_bw),':','color', c4,'linewidth' ,3)
grid on
title('g(s) magnitude' )
xlabel('\omega  rad/s' )
ylabel('db')
legend('ct','pz', 'tustin','prewarp')

% phase g
subplot(2,2,2)
semilogx(w,pg, 'color',c1,'linewidth',3)
hold on
semilogx(w,pg_pz,'--','color',c2,'linewidth',2)
semilogx(w,pg_tu,'-.','color',c3,'linewidth',2)
semilogx(w,pg_bw,':','color' ,c4, 'linewidth',3)
grid on
title('g(s) phase ')
xlabel('\omega rad/s')
ylabel('deg')

% magnitude h
subplot(2,2,3)
semilogx(w,20*log10(mh),'color',c1,'linewidth',3)
hold on
semilogx(w,20*log10(mh_pz),'--','color',c2,'linewidth',2)
semilogx(w,20*log10(mh_tu),'-.','color',c3,'linewidth',2)
semilogx(w,20*log10(mh_bw),':','color',c4,'linewidth',3)
grid on
title('h(s) magnitude')
xlabel('\omega rad/s')
ylabel('db')
legend('ct','pz','tustin','prewarp')

% phase h
subplot(2,2,4)
semilogx(w,ph,'color',c1,'linewidth' ,3 )
hold on
semilogx(w,ph_pz,'--','color',c2,'linewidth',2)
semilogx(w,ph_tu,'-.','color',c3,'linewidth',2 )
semilogx(w,ph_bw,':','color',c4,'linewidth',3)
grid on
title('h(s) phase')
xlabel('\omega  rad/s ')
ylabel('deg' )
