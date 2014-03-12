#serialPort="/dev/ttyUSB0"

import serial
import gtk

#ser=serial.Serial(serialPort);

mainWindow = gtk.Window()
entry_alt = gtk.Entry(5)
entry_az = gtk.Entry(6)
error_dialog = gtk.MessageDialog(mainWindow, gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_ERROR, gtk.BUTTONS_OK, "That was invalid! Please try again.")
aboutdialog = gtk.AboutDialog()
aboutdialog.set_name("ITSP GoTo Telescope System")
aboutdialog.set_version("1.0")
aboutdialog.set_comments("GoTo Telescope System with Gesture Control Support!")
aboutdialog.set_authors(["Manmohan Mandhana, Alankar Kotwal"])


class ITSP:
	
	def __init__(self):
		table = gtk.Table(4, 4, True)
		button_goto = gtk.Button("Go!")
		button_about = gtk.Button("About")
		button_messiers = gtk.Button("Messier List")
		button_quit = gtk.Button("Quit")
		label_alt = gtk.Label("Alt:")
		label_az = gtk.Label("Az:")
		label_main = gtk.Label("Welcome to GoTo System!")
		label_ins = gtk.Label("Enter the Alt and Az strictly as xx.xx and xxx.xx respectively")

		mainWindow.connect("destroy", lambda q: gtk.main_quit())
		button_goto.connect("clicked", self.goto)
		button_about.connect("clicked", self.about)
		button_messiers.connect("clicked", self.messiers)
		button_quit.connect("clicked", lambda r: gtk.main_quit())
		
		mainWindow.add(table)
		table.attach(label_main, 0, 4, 0, 1)
		table.attach(label_ins, 0, 4, 1, 2)
		table.attach(label_alt, 0, 1, 2, 3)
		table.attach(entry_alt, 1, 2, 2, 3)
		table.attach(label_az, 2, 3, 2, 3)
		table.attach(entry_az, 3, 4, 2, 3)
		table.attach(button_goto, 0, 1, 3, 4)
		table.attach(button_messiers, 1, 2, 3, 4)
		table.attach(button_about, 2, 3, 3, 4)
		table.attach(button_quit, 3, 4, 3, 4)
		
		mainWindow.show_all()
		
		
	def goto(self, widget):
		try:
			alt = float(entry_alt.get_text())
			az = float(entry_az.get_text())
			if alt<0 or alt>90 or az<0 or az>360:
				error_dialog.run()
				error_dialog.destroy()
			else:
				print str(int(100*alt))
				print str(int(100*az))
				#ser.write(str(int(100*alt)))
				#ser.write(str(int(100*az)))
		except ValueError:
			error_dialog.run()
			error_dialog.destroy()
		
	def about(self, widget):
		aboutdialog.run()
		aboutdialog.destroy()
		
	def messiers(self, widget):
		print "Messiers!"
		
ITSP()
gtk.main()
