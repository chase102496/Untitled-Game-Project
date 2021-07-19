/// See the documentation here:
/// https://github.com/DragoniteSpam/Documentation/wiki/Magpie
/// @author @DragoniteSpam

function conMagpieInventory() constructor {
    self.all_stacks = { };
    self.pockets = { };
    self.stacking_mode = true;
    
    /// @param mode true for items to be displayed grouped togehter, false for items to be displayed individually
    /// @return n/a
    static SetStackingMode = function(mode) {
        self.stacking_mode = mode;
    };
    
    /// @param item The item data to add
    /// @param [quantity] The quantity to add (optional, defaults to 1)
    /// @param [pocket] The item pocket to add to (optional)
    /// @param return n/a
    static Add = function()
	{
        var item = argument[0];
        var quantity = (argument_count > 1) ? max(argument[1], 1) : 1;
        var pocket = (argument_count > 2) ? argument[2] : undefined;
        var stack = self.all_stacks[$ item];
        if (stack)
		{
            stack.Add(quantity, pocket);
        }
		else
		{
            var stack = new self.itemStack(item, quantity, pocket);
            self.all_stacks[$ item] = stack;
            if (pocket != undefined)
			{
                if (self.pockets[$ pocket] == undefined) self.pockets[$ pocket] = { };
                self.pockets[$ pocket][$ item] = stack;
            }
        }
    }
    
    /// @param item The item data to remove
    /// @param [quantity] The quantity to remove (optional, defaults to 1)
    /// @param return n/a
    static Remove = function() {
        var item = argument[0];
        var quantity = (argument_count > 1) ? max(argument[1], 1) : 1;
        var stack = self.all_stacks[$ item];
        if (stack) {
            if (stack.Remove(quantity)) {
                variable_struct_remove(self.all_stacks, item);
                if (stack.set_pocket != undefined) {
                    variable_struct_remove(self.pockets[$ stack.set_pocket], item);
                    if (variable_struct_names_count(self.pockets[$ stack.set_pocket]) == 0) {
                        variable_struct_remove(self.pockets, stack.set_pocket);
                    }
                }
            }
        }
    };
    
    /// @param return n/a
    static Clear = function() {
        self.all_stacks = { };
        self.pockets = { };
    };
    
    /// @return { item, quantity }
    static Get = function() {
        var item = argument[0];
        var data = self.all_stacks[$ item];
        if (!data) return data;
        return { item: data.item, quantity: data.quantity };
    };
    
    /// @param [pocket] The item pocket to check (optional; will return the entire inventory if undefined)
    /// @param [sort_function] The sorting function to use; must accept two parameters of { item, quantity } and return -1, 0, or +1 (optional; leaving blank will not sort the returned list)
    /// @return Array<{ item, quantity }>
    static PocketContentsByGeneric = function() {
        var pocket = (argument_count > 0) ? argument[0] : undefined;
        var f = (argument_count > 1) ? argument[1] : undefined;
        if (pocket != undefined) {
            if (!self.pockets[$ pocket]) return [ ];
            var keys = variable_struct_get_names(self.pockets[$ pocket]);
        } else {
            var keys = variable_struct_get_names(self.all_stacks);
        }
        for (var i = 0, n = array_length(keys); i < n; i++) {
            keys[i] = self.all_stacks[$ keys[i]];
        }
        if (f != undefined) {
            array_sort(keys, f);
        }
        
        return self.keysToArray(keys);
    };
    
    /// @param [pocket] The item pocket to check (optional; will return the entire inventory if undefined)
    /// @return Array<{ item, quantity }>
    static PocketContentsByAlphabetical = function() {
        show_error("MagpieInventory::PocketContentsByAlphabetical - SETUP REQUIRED!\nThis method will ONLY work if inventory items are structs (or instances) containing a \"name\" property\nwhich contains a string (or some other comparable value). See the documentation for more details.\nAcknowledge this message by taking appropriate actions and\nremoving the thrown error in the code.", true);
        var pocket = (argument_count > 0) ? argument[0] : undefined;
        if (pocket != undefined) {
            if (!self.pockets[$ pocket]) return [ ];
            var keys = variable_struct_get_names(self.pockets[$ pocket]);
        } else {
            var keys = variable_struct_get_names(self.all_stacks);
        }
        for (var i = 0, n = array_length(keys); i < n; i++) {
            keys[i] = self.all_stacks[$ keys[i]];
        }
        array_sort(keys, function(a, b) {
            return a.item.name > b.item.name;
        });
        
        return self.keysToArray(keys);
    };
    
    /// @param [pocket] The item pocket to check (optional; will return the entire inventory if undefined)
    /// @return Array<{ item, quantity }>
    static PocketContentsByQuantity = function() {
        var pocket = (argument_count > 0) ? argument[0] : undefined;
        return self.PocketContentsByGeneric(pocket, function(a, b) {
            return a.quantity > b.quantity;
        });
    };
    
    /// @param [sort_function] The sorting function to use; must accept two parameters and return -1, 0, or +1 (optional; leaving blank will not sort the returned list)
    /// @return Array<pocket>
    static GetPockets = function() {
        var f = argument[0];
        var keys = variable_struct_get_names(self.pockets);
        if (f != undefined) {
            array_sort(keys, f);
        }
        return keys;
    };
    
    static itemStack = function(item, quantity, pocket) constructor {
        self.item = item;
        self.quantity = quantity;
        self.set_pocket = pocket;
    
        static Add = function(number, pocket) {
            self.quantity += number;
            if (self.set_pocket == undefined && pocket != undefined) {
                self.set_pocket = true;
            }
        };
    
        // returns whether or not the stack is empty
        static Remove = function(number) {
            self.quantity -= number;
            return (self.quantity <= 0);
        };
    }
    
    static keysToArray = function(stacks) {
        static k2aAdd = function() {
            var collection = argument[0];
            var index = 1;
            var arr = collection[@ 0];
            repeat (argument_count - 1) {
                if (array_length(arr) <= collection[@ 1]) {
                    var new_arr = array_create(array_length(arr) * 2, undefined);
                    array_copy(new_arr, 0, arr, 0, array_length(arr));
                    arr = new_arr;
                    collection[@ 0] = new_arr;
                }
                arr[@ collection[@ 1]++] = argument[index++];
            }
        };
        var results = [array_create(10), 0];
        for (var i = 0, n = array_length(stacks); i < n; i++) {
            var stack = stacks[i];
            if (self.stacking_mode) {
                k2aAdd(results, stack);
            } else {
                repeat (stack.quantity) {
                    k2aAdd(results, new self.itemStack(stack.item, 1));
                }
            }
        }
        var slice = array_create(results[@ 1]);
        array_copy(slice, 0, results[@ 0], 0, results[@ 1]);
        return slice;
    };
}