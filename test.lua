local sha2 = require("sha2");

local function test(func, input, expected)
	local digest = func(input);

	if digest ~= expected then -- lul, thanks
		print(input);
		print(digest);
		print(expected);
		error("Test failed");
	end
end

--[[
test(sha2.sha224, "abc",
       "f5c93b6f06f7c56d7ea720c121e3b1fb6730e5cf5f18d776bf0f2d88");
--]]

test(sha2.sha256, "abc",
	   "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
test(sha2.sha256,
       "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
       "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1");
test(sha2.sha256, ("a"):rep(1e6),
       "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0");

local s = ("a"):rep(200* 2^20); -- x * 1MB
local sha256 = sha2.sha256;
local time = os.clock();
local output = sha256(s);
print(os.clock()-time, output);
-- 3.93
-- 3.24
-- 3.35, 3.31, 3.3
-- 3.2, 3.18, 3.18
-- 3.13, 3.11
-- 3.08, 3.13, 3.1, 3.03
-- 2.91
--[==[
do
	local s = [[
	428a2f98
	d807aa98
	e49b69c1
	983e5152
	27b70a85
	a2bfe8a1
	19a4c116
	748f82ee
	71374491
	12835b01
	efbe4786
	a831c66d
	2e1b2138
	a81a664b
	1e376c08
	78a5636f
	b5c0fbcf
	243185be
	0fc19dc6
	b00327c8
	4d2c6dfc
	c24b8b70
	2748774c
	84c87814
	e9b5dba5
	550c7dc3
	240ca1cc
	bf597fc7
	53380d13
	c76c51a3
	34b0bcb5
	8cc70208
	3956c25b
	72be5d74
	2de92c6f
	c6e00bf3
	650a7354
	d192e819
	391c0cb3
	90befffa
	59f111f1
	80deb1fe
	4a7484aa
	d5a79147
	766a0abb
	d6990624
	4ed8aa4a
	a4506ceb
	923f82a4
	9bdc06a7
	5cb0a9dc
	06ca6351
	81c2c92e
	f40e3585
	5b9cca4f
	bef9a3f7
	ab1c5ed5
	c19bf174
	76f988da
	14292967
	92722c85
	106aa070
	682e6ff3
	c67178f2
	]]

	local words = {}; for word in s:gmatch("(%x+)%s") do words[#words + 1] = tonumber(word,16); end

	local right = true;
	for i = 1, 8 do
		for y = 1, 2 do
			local mini = {};
			for j = 1, 4 do
				mini[#mini + 1] = words[(y==1 and 0 or 32)+i+(j-1)*8]
			end
			print(("0x%08x, 0x%08x, 0x%08x, 0x%08x,"):format(unpack(mini)));
		end
	end
end
--]==]