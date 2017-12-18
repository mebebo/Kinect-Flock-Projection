// Kinect
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;


void initializeKinect() {
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
}