local cim = require 'call_in_mainthread'

describe("This module", function()
  it("can execute a function",
    function()
      local status, info, costatus
      local tab = {}
      local function f()
        for i=1,3 do
          costatus = cim.mainthread_call(table.insert, tab, i)
        end
      end
      local co = coroutine.create(f)
      repeat
        status, info = coroutine.resume(co)
        cim.mainthread_process()
      until not status
      assert.is_equal( true, costatus )
      assert.is_equal( "123", table.concat(tab) )
    end)

  it("can deal with errors in functions",
    function()
      local status, info, costatus, res
      local tab = {}
      local function f()
        costatus, res = cim.mainthread_call(error, "error msg")
      end
      local co = coroutine.create(f)
      repeat
        status, info = coroutine.resume(co)
        cim.mainthread_process()
      until not status
      assert.is_equal( false, costatus )
      assert.is_equal( "error msg", res )
    end)

end)
  
