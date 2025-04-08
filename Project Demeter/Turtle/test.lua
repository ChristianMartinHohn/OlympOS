-- Ein einfacher Test-Table als Liste
local testTable = {1, 2, 3, 4, 5}

-- Beispiel: Zugriff auf Elemente
for i, value in ipairs(testTable) do
    print("Index:", i, "Wert:", value)
end

print("---")
table.remove(testTable) -- Entfernt das Element an Index 2 (Wert 2)
table.remove(testTable) -- schein das letzte element zu entfernen

for i, value in ipairs(testTable) do
    print("Index:", i, "Wert:", value)
end