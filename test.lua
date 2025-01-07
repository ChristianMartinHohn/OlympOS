--alsoooo die lage ist die Mine_Resource_Node wird getriggered sobald die Turtle vor einer Resource steht. Hierbei wird übergeben ob die Resource Über/Vor/Unter der Turtle ist.
--Jz ist nur das ding wie ich das mache. Ich denke ich werde eine Map erstellen die die Resource darstellt und dann die Turtle sich die Resource abbauen lassen
--Wichtig wäre halt das keine Resourcen übersehen werden und die Turtle nicht unnötig oft herumfährt.
--Auch muss die Turtle danach wieder in der Richtigen Stellung sein um weitert zu Minen.
--Dann noch zwischendurch nh Message an Demeter schicken das jetzt Ge-mined wird und was für eine Resource das ist.

function Mine_Resource_Node(direction) --absolut kp wie das gemacht wird
    local resource_start_point = GetCurPosition()
    local custom_resource_map = {}
    if direction == "FORWARD" then
        Movement("FORWARD", 1)
    end
end