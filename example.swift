
//Example
let x = Node(value: 2)
let y = Node(value: 3)
let u = Node(value: 2)
let z = x*y
let c = z+u
c.backward()

print(x.grad) //Output: 3.0 gives the gradient of c w.r.t x
