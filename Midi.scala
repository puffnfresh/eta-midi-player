import java.io.{File, FileInputStream, InputStream}
import javax.sound.midi.{MidiSystem, Sequencer}

object Main {
  def main(args: Array[String]): Unit = {
    val sequencer: Sequencer = MidiSystem.getSequencer
    sequencer.open
    val is: InputStream = new FileInputStream(new File(args.head))
    sequencer.setSequence(is)
    sequencer.start
  }
}
