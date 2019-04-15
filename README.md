# Gallery

<img align="right" src="gallery2.gif">

## Overview

IPad App which lets user creating image galleries via draging and dropping images from web. Galleries are persistent with
the use of realm database and filesystem (for image data). 

## Implemented bits
* splitViewController
* showing gallery names in tableView - master view controller, showing particular gallery via collectionView - detail
view controller
* custom tablie view cell, custom collection view cell
* saving and retrieving images from filesystem
* realm model objects
* creating custom protocol, implementing textfield delegate methods
* scroll view, zooming & panning, delegate methods, centering content
* saving, loading, updating data in realm db
* add gesture recognizers to view - pinch, double tap...
* implementing collectionViewFlowLayout delegate methods
* enabling user to zoom in and out on collection view
* implementing drag & drop delegate methods
* fetching images asynchronously with alamofire, promisekit

