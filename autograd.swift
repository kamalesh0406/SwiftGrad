import Foundation

class Node: Equatable{
    
    var value: Float
    var grad: Float
    
    var children: [Node]
    var _backward = {()->Bool in return false}
    
    init(value: Float, children: [Node] = []) {
        self.value = value
        self.grad = 0
        
        self.children = children
    }
    
    static func +(left: Node, right: Node) -> Node{
        var out = Node(value: left.value + right.value, children: [left, right])
        out._backward = { () -> Bool in
            left.grad += out.grad
            right.grad += out.grad
            return true
        }
        
        return out
    }
    
    static func *(left:Node, right:Node) -> Node{
        var out = Node(value: left.value * right.value, children: [left, right])
        out._backward = { () -> Bool in
            left.grad += right.value * out.grad
            right.grad += left.value * out.grad
            return true
        }
        
        return out
    }
    
    static func /(left:Node, right:Node) -> Node{
        let out = Node(value: left.value / right.value, children: [left, right])
        out._backward = { () -> Bool in
            left.grad += 1.0 / right.value * out.grad
            right.grad += -(left.value / pow(right.value, 2) * out.grad)
            return true
        }
        
        return out
    }
    func sigmoid() -> Node{
        let output = 1/(1+exp(-self.value))
        let out = Node(value: output, children: [self])
        
        out._backward = { () -> Bool in
            self.grad += out.grad * out.value * (1-out.value)
            return true
        }
        return out
    }
    
    func backward(){
        var graph:[Node] = []
        
        func findChild(node: Node){
            if !graph.contains(node){
                for children in node.children{
                    findChild(node: children)
                }
                graph.append(node)
            }
        }
        findChild(node: self)
        
        self.grad = 1
        for value in graph.reversed(){
            _ = value._backward()
        }
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        if (lhs.value==rhs.value) && (lhs.children == rhs.children){
            return true
        }
        else{
            return false
        }
    }
}

