---
published: true
layout: post
title: Pulizia e ottimizzazione di un computer Windows
---
**Nota: questo post è una libera traduzione di un [post di decent security](https://decentsecurity.com/holiday-tasks).
Trovate il suo lavoro presso [https://decentsecurity.com]()**

** Questa pagina è in costruzione **

__[Pagina aggiornata l'ultima volta il 2022-01-18]__

> "Faccio del mio meglio per rendere tutto questo il più facile possibil,e ma ci sono diverse tecniche avanzate in questa guida rispetto al resto del sito"

Questa è una guida alla risoluzione di problemi e manutenzione per Windows 7 e successivi. Vi aiuterà inoltre a rimuovere molti virus e riparare i danni causati da essi. Queste procedure possono essere d'aiuto per macchine anche piuttosto vecchie. Se il tuo computer è una macchina di lavoro, chiedete consiglio al vostro referente tecnico IT prima di procedere.

Tutti questi task sono stati eseguiti da me o da miei script su decine, centinaia o a volte migliaia di computer. Potete leggere le mie qualifiche [qui](https://decentsecurity.com/#/introduction/).

L'ordine delle sezioni è voluto. Per esempio - eliminare alcuni programmi, eliminare i file temporanei, e poi riavviare può lasciare i programmi in uno stato inconsistente.

**Non usare strumenti per pulire il registro o ottimizzatori di sistema. [Leggi perchè.](https://decentsecurity.com/#/registry-cleaners/)**

**Prestare attenzione utilizzando strumenti per rimuovere le telemetrie o migliorare la privacy di Windows 10**. Essi possono modificare parametri di sistema che non dovrebbero, e inavvertitamente **disattivare funzioni di sicurezza**, rendendovi vulnerabili e danneggiando funzionalità di Windows. So che è invitante "mettere il turbo al tuo PC" con strategie tipiche dei tempi di Windows XP, ma ricordate che questi strumenti mettono mano a funzionalità di basso livello che non comprendete.

**Se state aggiornando a Windows 7 un computer che è stato spento per oltre un anno, o state installando da zero**, ci sono dei problemi noti. Seguite questa guida per risparmiarvi ore di lavoro: [Windows 7 Fast Update](https://decentsecurity.com/enterprise/#/windows-7-fast-update/).

## 1.) Controllo del disco fisso e eventuali errori prima di partire

- I dischi fissi possono essere una causa silente di diversi errori inspiegabili, rallentamenti, e crash. Il mio strumento preferito è [WinDlg di Western Digital](http://download.wdc.com/windlg/WinDlg_v1_29.zip). Non serve installarlo e funziona con qualunque disco di qualunque marca.
Scaricate il file, eseguite windlg.exe, e fate doppio-click sul disco per fare un controllo veloce. Ci vogliono dai 2 ai 10 minuti.
- Lo strumento integrato di [Monitoraggio Affidabilità o "Visualizza cronologia affidabilità"](https://www.howtogeek.com/166911/reliability-monitor-is-the-best-windows-troubleshooting-tool-you-arent-using/) vi mostrerà lo storico degli errori e dei problemi sulla vostra macchina.
- [Per esperti] Controllate se ci sono state schermate blu (bugcheck) con [BlueScreenView](https://www.nirsoft.net/utils/blue_screen_view.html).

## 2.) Rimozione programmi spazzatura

Questa sezione è i più tecnici. Se non siete sicuri su cosa fare, riavviate e saltate questa sezione.
- Start > scrivi "Programmi e funzionalità"/"App e funzionalità" > Invio

Da questa finestra, disinstalla tutto quello che sembra essere non rilevante o indesiderato. Leggi le videate MOLTO ATTENTAMENTE per essere sicuro di non lasciare tracce dei programmi rimossi accettando qualche clausola. Se **non** sai cosa sia rilevante o non sei sicuro, non rimuovere alcun programma.
Va tutto bene, vedremo più avanti il da farsi.

Se l'antivirus è non aggiornato o scaduto o ha problemi, rimuovilo ora. Un antivirus che non sia aggiornato a _ieri_ è essenzialmente inutile. Se l'uninstaller dell'antivirus è rotto, potete usare questo strumento per la rimozione manuale: [ESET AV Remover](https://help.eset.com/ees/6/en-US/?av_remover.htm).

# BREAK 1 - Riavvia prima di procedere con i passi successivi

## 3.) Pulire windows con cleanmgr.exe

Potete liberare giga di spazio (spesso 6GB e oltre) pulendo WinSxS, cosa che nessuno strumento può toccare con tranquillità. Lo strumento integrato in windows è stato [migliorato con Windows Update nel 2013](https://blogs.technet.microsoft.com/askpfeplat/2013/10/08/breaking-news-reduce-the-size-of-the-winsxs-directory-and-free-up-disk-space-with-a-new-update-for-windows-7-sp1-clients/). Non fate questo passo in Windows XP.

1. Start > scrivi "cleanmgr" > premi **Ctrl+Shift+Invio** per eseguire come amministratore.
2. Seleziona la linguetta "Pulizia Disco" > seleziona tutto tranne "Downloads" o "Scaricati" > premi _OK_

Lo strumento di pulizia si chiuderà da solo una volta che ha finito. Non è necessario aspettare che termini, procedete con il prossimo passo.

## 4.) Pulizia cache Windows Update

Svuotate completamente la cache di Windows Update. Questa procedura è sicura. La cartella verrà rigenerata.

1. Start > scrivi "servuces.msc" > premi Invio
2. "Servizio trasferimento intelligente in background" > click destro > _Stop_
3. "Windows Update" > click destro > _Stop_.
4. Rimuovete la cartella `C:\Windows\SoftwareDistribution`. Se non è consentito, fermate di nuovo i servizi con i punti 1-3.

Non è necessario riavviare manualmente i servizi di cui sopra.

## 5.) Rimozione file temporanei con Bleachbit

Normalmente non ci sarebbe ragione di ricorrere a strumenti come Bleachbit. Tuttavia questo ci rende molto facile e veloce il compito di ridurre il numero di file che l'antivirus deve scansionare. Preferisco non indicare ciascuna directory da pulire per farlo a mano.

1. Scarica ed installa [Bleachbit](https://www.bleachbit.org/)
2. Lancia Bleachbit
3. Spunta le seguenti opzioni:
    1. Flash > Everything
    2. Internet Explorer > Everything
    3. System > Logs
    4. System > Memory dumps
    5. System > Recycle bin
    6. System > Temporary files
4. Lancia la pulizia (clean)

Quando cleanmgr e Bleachbit hanno finito, **RIAVVIA**.

# BREAK 2 - Riavvia prima di procedere con quanto segue

## 6.) Scansione veloce con antivirus

Lanciate la seguente anche se si ha un antivirus. Questi sono strumenti semplici per una scansione veloce.
A questo punto, **disattivate temporaneamente il vostro antivirus** o rimuovetelo finchè non avete terminato di seguire questa guida.

1. [Microsoft Safety Scanner](https://www.microsoft.com/security/scanner/en-us/default.aspx) - Questo è un antivirus senza installazione in un unico EXE (un unico eseguibile, ndt) direttamente da Microsoft. Lanciate una scansione veloce (quick scan). Dovrebbero bastare 10 minuti. Il file pesa circa 160 MB al momento della pubblicazione.
2. [Kaspersky Virus Removal Tool](https://www.kaspersky.com/downloads/thank-you/free-virus-removal-tool?form=1)

## 7.) Controllo e rimozione di malware o software spazzatura

Usate questi strumenti se avete il sospetto che il computer non sia pulito o se ha avuto una infezione in passato.

1. [MalwareBytes AdwCleaner](https://www.malwarebytes.com/adwcleaner/) è uno strumento poco conosciuto ma molto efficace per rimuovere quelle piccole cose che insidiano un computer. Controllate con cura le raccomandazioni che vi si presentano prima di accettarle. Necessita di un riavvio dopo l'uso.

2. [MalwareBytes Anti-Malware](https://www.malwarebytes.com/) è il mio strumento di pulizia automatica più gettonato per la pulizia da software malevolo e contro cambiamenti non desiderati del sistema. Se l'utente del computer tende ad installare software di dubbia origine, considerate di acquistare la versione Premium.

3. [Google Chrome Cleanup Tool](https://www.google.com/chrome/cleanup-tool/) è un piccolo strumento da Google che usa il motore antivirus ESET per rimuovere software spazzatura. Non è necessario resettare Chrome se non pensate che sia rotto o rovinato.

## 8.) Controllo di Windows Update e Firewall

Un classico segnale di infezione è se le seguenti impostazioni non possono essere abilitate o non funzionano. Sistematele.

1. _Start_ > scrivete "Windows Update" > Invio

    Controllate gli aggiornamenti. Se non funziona, prendete nota e continuate.
2. _Start_ > scrivete "Windows Firewall" > Invio

    Assicuratevi che sia attivo o che dica di essere gestito da un altro programma. Se desiderate tenerlo spento, almeno assicuratevi che si accenda se lo attivate.
    Se non funziona, prendete nota e continuate.

- Se non funziona Windows Update, riparatelo con [Microsoft Windows Update FixIt tool](https://aka.ms/diag_wu).
- Se non funziona Windows Firewall, riparatelo con [Microsoft Windows Firewall FixIt tool](https://support2.microsoft.com/mats/windows_firewall_diagnostic/).

Se nessuno dei precedenti funziona, potete provare [Windows services repair tool](http://download.webroot.com/wsvcscan.exe) di [Webroot](http://www.webroot.com/) o il [Services repair tool](http://www.wintips.org/how-to-restore-windows-services-to-their-default-state/) di [ESET](https://www.eset.com/).

## 9.) DISM RestoreHealth (Windows 8 e successivi)

Questo comando scansionerà il sistema alla rierca di componenti Windows corrotti, e cercherà di ripararli. Ci vorranno 20 minuti.

1. Start > scrivete "cmd.exe" > premete Ctrl + Shitf + Invio
2. Apparirà una finestra nera
3. Scrivete "dism /Online /Cleanup-Image /RestoreHealth"
4. Se il testo (in inglese) dice che è stato riparato qualcosa, riavviate il computer.

## 10.) Installate gli aggiornamenti di Windows e configurate l'aggiornamento automatico

Controllate gli aggironamenti e assicuratevi siano impostati per l'aggiornamento automatico.

Se ci sono problemi ad installare gli aggiornamente, provate i passi di seguito. Sfortunatamente ci sono situazione per cui Windwos non può essere ragionevolmente riparato. Tuttavia da Windows 8 in avanti c'è il comando DISM a disposizione per riparare la maggior parte delle corruzioni se ce ne fosse bisogno.

### Se gli aggiornamenti falliscono Step 0 - Procedura Microsoft

Microsoft mantiene una [procedura guidata di riparazione](https://support.microsoft.com/en-us/help/10164/fix-windows-update-errors) per aiutarvi a sistemare gli errori di Windows. Siccome sono l'azienda autore di Windows, dovreste prima seguire le loro procedure.

### Se gli aggiornamenti falliscono Step 1 - Microsoft FixIt

Lanciate lo [strumento di riparazione Windows Update](https://support.microsoft.com/it-it/windows/strumento-di-risoluzione-dei-problemi-di-windows-update-per-windows-10-19bc41ca-ad72-ae67-af3c-89ce169755dd) e riavviate.

### Se gli aggiornamenti falliscono Step 2 - Controllo dell'integrità dei file di sistema

1. Start > scrivete "cmd.exe" > premete Ctrl+Shift+INvio per avviare come Administrator
2. Apparirà una finestra nera
3. Scrivete "dism /online /cleanup-image /restorehealth" senza i doppi apici e premete Invio (non funziona su Windows 7)
4. Scrivete "sfc /scannow" senza i doppi apici e premete Invio. Quanto ha finito continuate al passo successivo.
5. Riavviate e ricontrollate gli aggiornamenti di Windows.

### Se gli aggiornamenti falliscono Step 3 - Microsoft FixIt (solo Windows 7)

Se avete Windows 7, segutie le istruzioni per scaricare ed eseguire [Microsoft Fixit 50202](https://go.microsoft.com/?linkid=9665683) (link rotto al 2021-08-27).

### Se gli aggiornamenti falliscono Step 4 - Ripristino di catroot2 e componenti di Windows Update

1. [Ripristinate la cartella catroot2](http://www.thewindowsclub.com/catroot-catroot2-folder-reset-windows) (mi raccomando cancellate il contenuto, non la cartella!)
2. Scaricate ed estraete il "Reset Windows Update Tool" in una cartella del vostro desktop (link rotto al 2021-08-27, provare con [https://docs.microsoft.com/en-us/windows/deployment/update/windows-update-resources](https://docs.microsoft.com/en-us/windows/deployment/update/windows-update-resources) per windows 10)
3. Tasto destro su _ResetWUEng.cmd_ > Esegui come _amministratore_
4. Selezionare opzioni 2, 5, 8, 9, 10, 12, riavviate, poi verificare se la presenza di aggiornamenti windows

### Se gli aggiornamenti falliscono Step 5 - Controllare se esistono soluzioni a problemi noti

Controllate questa pagina di Microsoft Answers se comprende il vostro codice di errore o sintomi e seguite le istruzioni:
[How to: Troubleshoot Common Setup and Stop Errors](https://answers.microsoft.com/en-us/insider/wiki/insider_wintp-insider_install/how-to-troubleshoot-common-setup-and-stop-errors/324d5a5f-d658-456c-bb82-b1201f735683)

### Se gli aggiornamenti falliscono Step 6 - Strumento Microsoft SUR (solo Windows 7)

1. Scaricate ed installate [Microsoft System Update Readiness Tool](https://www.microsoft.com/en-us/download/details.aspx?id=20858). (Windows 7 only) (link rotto al 2021-08-27)
2. Cercate la sezione 21 a in fondo, "Install Windows 7 hotfix rollup"

### Se gli aggiornamenti falliscono Step 7 - Controllo del disco con chkdsk

Controllate se il vostro disco rigido presenta problemi.

1. Start > scrivete "cmd.exe" > Ctrl-Shift-Invio (esegui come amministratore)
2. Apparrirà una finestra nera, il prompt dei comandi
3. Scrivete "chkdsk /r" senza doppi apici.
4. Premete "y" (o "s" in italiano) e premete Invio
5. Riavviate il computer
6. Ritornate al "Se gli aggiornamenit falliscono Step 1" se il controllo disco ripara qualcosa del vostro disco

### Se gli aggiornamenti falliscono Step 8 - Rimozione antivirus e reset componenti di rete

Disinstallate il vostro antivirus, riavviate, e [seguite le seguenti istruzioni](https://www.hanselman.com/blog/TheNuclearOptionResettingTheCrapOutOfYourNetworkAdaptersInVista.aspx). Tenete a mente che dovrete reinstallare eventuali software tipo VPN dopo questa operazione. Se non sapete cosa sia una VPN, allora non dovete preoccuparvene.

### Se gli aggiornamenti falliscono Step 9 - Aggiornamento driver

Seguite la sezione 20 di questa guida.

### Se gli aggiornamenti falliscono Step 10 - CheckSUR.log

Questo vale solo per Windows 7, ed è estremamente raro che ce ne sia bisogno. Avviso: questa sezione è altamente tecnica.

1. Prima di tutto lanciate una scansione per stabilire la salute del disco con [WinDlg](http://download.wdc.com/windlg/WinDlg_v1_29.zip) di Western Digital
2. Seguite questa guida [https://support.microsoft.com/en-us/kb/2700601](https://support.microsoft.com/en-us/kb/2700601)

### Se gli aggiornamenti falliscono Step 11 - Modificate la sezione COMPONENTS

1. Start > scrivete "cmd.exe" > Ctrl-Shift-Invio (esegui come amministratore)
2. Apparrirà una finestra nera, il prompt dei comandi
3. Scrivete i seguenti comandi e premete invio dopo ciascuno:
    - `REG LOAD HKLM\COMPONENTS C:\Windows\System32\config\COMPONENTS`
    - `REG DELETE HKLM\COMPONENTS /V PendingRequired`
4. Riavviate e controllate gli aggiornamenti di windows.

([Fonte - Karen Hu](https://social.technet.microsoft.com/Forums/windows/en-US/8d63fe26-5e33-4c5e-ab4c-e19611aa95a7/update-install-error-0x80070308?forum=w7itproinstall))

## 11.) Scansione veloce con SecureAnywhere System Analyzer

[SecureAnywhere System Analyzer](http://anywhere.webrootcloudav.com/zerol/syswranalyzer.exe) di [Webroot](http://www.webroot.com/) fa una scansione veloce di processi e parti importanti del sistema per oggetti catalogati come malevoli nel "cloud". Il suo passaggio attiva virus e programmi spazzatura, e non pulisce, quindi normalmente volete lanciarlo dopo che avete fatto un po' di pulizia. Serve solo a raccogliere informazioni per la vostra diagnosi.

## 12.) Pulizia di WinSxS con ResetBase (Windows 8+)

Questa procedura di pulizia va più a fondo del comando che abbiamo lanciato all'inizio. Dovevamo essere sicuri che il sistema fosse funzionante prima di fare pulizia di vecchi file di Windows. [Clicca qui per spiegazione tecnica su cosa avviene.](https://msdn.microsoft.com/en-us/windows/hardware/commercialize/manufacture/desktop/clean-up-the-winsxs-folder)

1. Start > type `cmd.exe` > Ctrl-Shift-Invio (esegui come amministratore)
2. Scrivete: `Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase`
3. Invio

## 13.) Controllo dell'account utente al massimo

**Ascoltatemi**. O ascoltate uno dei [programmatori Microsoft più esperti](https://blogs.msdn.microsoft.com/oldnewthing/20160816-00/?p=94105). UAC (controllo account utente) è un sistema importante che ha impatti profondi nel sistema, in aree che normalmente non sono visibili. Non è come l'imballaggio con le bolle da togliere prima dell'uso. Esiste per ragioni importante, non è *cool* toglierlo.

[Segui queste istruzioni](https://www.tenforums.com/tutorials/3577-change-user-account-control-uac-settings-windows-10-a.html) (o [segui queste per istruzioni in italiano](https://support.microsoft.com/it-it/topic/guida-interattiva-regolare-le-impostazioni-di-controllo-dell-account-utente-in-windows-7-e-windows-8-605f891d-42c5-2b93-4b4b-e4c5d4d35f60), ndt) per impostare UAC al massimo, o "Notifica sempre". Qualsiasi valore minore permeterebbe ai malware di eseguire istantaneamente operazioni con privilegi di amministrazione. UAC non è magia, è uno livello di protezione che volete usare.

## 14.) Abilitare SmartScreen (Windows 8+)

Questo strumento verifica assieme a Microsoft e avvisa l'utente nel caso si scarichi ed esegua dei programmi non comunemente usati. Questo controllo previene la maggior parte delle infezioni originate da mail fasulle a meno che l'utente non scelga di procedere nonostante l'avviso di cautela.

1. Start > Scrivete `SmartScreen` (o `Protezione basata sulla reputazione` nelle versioni italiane, ndt) > Clicca "Cambia impostazioni SmartScreen" (in versioni successive si dovrebbe arrivare già sulla schermata con le impostazioni di SmartScreen, ndt)
2. Sulla sinistra, clicca "Cambia impostazioni Windows SmartScreen"
3. Seleziona "Chiedi approvazione dell'amministratore" (Windows 8) o "Controlla app e file" (Windows 10)

Nota del traduttore: aggiornamenti recenti di windows hanno cambiato nomenclatura e abilitato nuove funzioni di SmartScreen, se si entra su "Protezione basata sulla reputazione" il consiglio è abilitare tutte le funzioni. Ogni selettore abilita una variante di SmartScreen focalizzata su diverse categorie di file e programmi. Come indicato sopra, questi controlli prevengono infezioni da programmi malevoli.

## 15.) Pulizia e re-inizializzazione del servizio di ricerca di Windows (Windows Search)

Windows ha un sistema integrato di ricerca e indicizzazione chiamato Windows Search e per utenti con grandi quantità di dati i file di indice possono raggiungere dimensioni di diversi gigabyte. Inoltre Windows Search può occasionalmente corrompersi. Normalmente il servizio si fa manutenzione in autonomia, ma è possibile "resettarlo" al bisogno. La pulizia può liberare anche un gigabyte o più specie se si usa molto Outlook. Questa pulizia va oltre il normale comando di re-indicizzazione di Windows Search, che personalmente trovo poco efficace (a detta dell'autore, ndr).

Questa procedura non è documentata, l'ho imparata dopo ore di ricerca e diagnosi su svariate istanze di Outlook con problemi di ricerca.

1. Start > Scrivete `cmd.exe` > Premete Ctrl-Shift-Invio (esegui come amministratore)
2. Dare i seguenti comandi e premere Invio dopo ciascuno:
   1. `net stop WSearch`
   2. `RD /S /Q "C:\ProgramData\Microsoft\Search"`
   3. `regedit`
3. In Regedit, trovate e cancellate le seguenti chiavi e cartelle (aiutetevi con la ricerca, ndr):
   - Sotto "Current User": `HKEY_CURRENT_USER\Software\Microsoft\Windows Search`
   - Poi, sotto "Local Machine": `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Search\SetupCompletedSuccessfully`

## 16.) Pulizia e aggiornamento browser

**Verificate manualmente che ogni browser che utilizzate sia alla sua ultima versione**

Se l'utente è prono a infettarsi con malware o altri programmi che prendono possesso del computer, o ad avere problemi di performance con i browser, probabilmente è il caso di cancellare la cache e resettare le impostazioni. In altri casi questo potrebbe risultare esagerato. Questi di seguito sono le modalità più semplici per reimpostare i browser, ma almeno sarete sicuri che il sistema sarà pulito.
**NOTA**: Queste procedure cancellano tutte le password e altri dati salvati.

### Microsoft Edge

Al momento non ho esperienza sul campo in merito a virus con questo browser, non ho suggerimenti.

### Google Chrome

Reimposteremo Chrome da zero.

1. [Esportare i preferiti di Chrome](https://support.google.com/chrome/answer/96816?hl=it)
2.   [Disinstallate Google Chrome](https://support.google.com/chrome/answer/95319?hl=it).
3. Start > Scrivete `%AppData%` > Premete Invio. Cancellate la cartella "Google".
4. Start > Scrivete `%AppDataLocal%` > Premete Invio. Cancellate la cartella "Google".
5. Cancellate la cartella `C:\Program Files (x86)\Google\Chrome`
6. Start > Scrivete `regedit.exe` > Premete Invio. Cancellate le chiavi `HKCU\Software\Policies\Google` e `HKLM\Software\Policies\Google`
7. Installate Google Chrome con l'[installer aziendale 64-bit MSI](https://cloud.google.com/chrome-enterprise/browser/download/) (scorrete in basso nella pagina). Potete installarlo anche normalmente se volete. Non vi serve aiuto per questo.
8. [Reimportate i preferiti di Chrome](https://support.google.com/chrome/answer/96816?hl=it).

### Mozilla Firefox

Reimposteremo Firefox da zero.

1. [Esportate i preferiti di Firefox](https://support.mozilla.org/it/kb/Esportare%20i%20segnalibri%20in%20Internet%20Explorer).
2. Disinstallate Mozilla Firefox
3. Start > Scrivete `%AppData%\Mozilla` > Premete Invio. Cancellate la cartella "Firefox".
4. Start > Scrivete `regedit.exe` > Premete Invio.Cancellate le chiavi `HKCU\Software\Policies\Mozilla` e `HKLM\Software\Policies\Mozilla`
5. Cancellate la cartella "Mozilla Firefox" sotto `C:\Program Files` e `C:\Program Files (x86)`
6. [Installate Firefox dal sito di Mozilla](https://www.mozilla.org/it/firefox/new/).
7. [Reimportate i preferiti in Firefox](https://support.mozilla.org/it/kb/Esportare%20i%20segnalibri%20in%20Internet%20Explorer).

### Internet Explorer

(Questa procedura andrebbe rivista perchè Microsoft ormai installa e raccomanda solo Edge e la sua modalità compatibilità, vi lascio la traduzione per comodità. ndr)
Riporteremo Internet Explorer alle sue impostazioni predefinite. Non è un reset al 100% ma ci si avvicina. Assicuratevi di avere Internet Explorer in versione 11. Per sicurezza faremo un backup dei preferiti (è una storia lunga, fidatevi).

1. [Esportate i preferiti di  Internet Explorer](https://kb.wisc.edu/helpdesk/page.php?id=1419)
2. Internet Explorer > Premere Alt > Strumenti > Opzioni Internet > Avanzate > Reset
3. Selezionate "Elimina impostazioni personalizzate" (la traduzione esatta potrebbe essere leggermente diversa, ndr) > Ok