# LogRelativeError

Tools for assessing the reliability of numerical calculations in a reproducible way in Swift.

### What is LRE?

A common method of measuring the precision of numerical results is a base-10 Log Relative Error (LRE). This provides an intuitive measure of precision as the number of correct decimal digits. LRE is defined as (McCullough, 1998, Eq 3 [^1]):

LRE = -log₁₀( |x - c| / |c| )

The scale of the measure runs from 0 (wrong sign or order of magnitude) up to the lesser of: (A) the number of digits provided in the reference value, or (B) the number of digits supported by the machine precision of the data type being used. For `Double` this is usually taken to be 15.

LRE can have fractional values. Another way to understand the scale is that LRE / log₁₀2 is the number of correct bits in the answer.

In the case of the reference value, `c`, being zero an absolute error variant is used (McCullough, Eq. 3):

LAR = -log₁₀( |x| )

We follow McCullough in calling both variants LRE.

### How to use this package to test numerical accuracy

The package provides a new assert function for use in `XCTest` tests. The new function is called `AssertLRE` and has a number of options. Here's a simple example:

```swift
let x = cbrt(3647963.0)
AssertLRE(x,"153.9395248014257")
```

In this example the reference value has more digits than `Double` supports so the assertion is only expecting the max supported by `Double`. You can also override how many digits to expect (but you still can't choose more than the data type supports):

```swift
AssertLRE(x,"153.9395248014257", digits: 12.5)
```

If your reference value has an exact representation you can also express that:

```swift
let x2 = cbrt(27.0)
AssertLRE(x2,"3", exact: true)
```

### How to output summary accuracy data

The package also supports storing the LRE measurements in a test class and then outputting a table of results. Some setup is required. The following must be added to your `XCTestCase` subclass:

```swift
override class func tearDown() {
    print(resultStore.md())
    super.tearDown()
}

static let resultStore: ResultStore = ResultStore()
var rs: ResultStore { return type(of: self).resultStore }
```

Then for each test you want in your output you must tell `AssertLRE` to store its result:

```swift
AssertLRE(x,"153.9395248014257", resultStore: rs, table: "Cube Root", testCase: "3647963", field: "cbrt")
```

Your output will be logged when your  `XCTestCase` subclass completes its tests.

[^1] "Assessing the Reliability of Statistical Software", B. D. McCullough, The American Statistician, Volume 52, Issue 4, Pages 358-366, 1998. 
