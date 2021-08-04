---
published: true
layout: post
title: Pulizia e ottimizzazione di un computer Windows
---
**Nota: questo post è una libera traduzione di un [post di decent security](https://decentsecurity.com/holiday-tasks).
Trovate il suo lavoro presso [https://decentsecurity.com]()**

** Questa pagina è in costruzione **

__[Pagina aggiornata l'ultima volta il 2019-07-28]__

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


