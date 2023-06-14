<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\UserRequest;
use Illuminate\Database\QueryException;
use Illuminate\Database\ValidationException;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Exception;

class UserController extends Controller
{
    public function login(Request $request)
    {
        try {
            $credentials = $request->only('name', 'password');
            if ($request->name === 'Admin') {
                $user = User::whereName($request->name)->first();
                if ($user && Hash::check($credentials['password'], $user->password)) {
                    if (Auth::attempt($credentials)) {
                        return response()->json(['message' => 'Access granted'], 200);
                    } else {
                        return response()->json(['message' => 'Invalid credentials'], 401);
                    }
                } else {
                    return response()->json(['message' => 'Invalid credentials'], 401);
                }
            } else {
                return response()->json(['message' => 'Access error'], 401);
            }
        } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }

    public function all()
    {
        try {
            $users = User::where('name', '!=', 'Admin')->get();
            return response()->json($users);
        } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }

    public function create(UserRequest $request)
    {
        try {
            $data = $request->all();
            $data['password'] = bcrypt($request->password);
            User::create($data);
            return response()->json(['message' => 'User created'], 200);
        } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (ValidationException $e) {
            return response()->json(['message' => $e->getMessage()], 409);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }

    public function edit(Request $request)
    {
        try {
            $user = User::findOrFail($request->id);
            return response()->json($user);
         } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }

    public function update(UserRequest $request)
    {
        try {
            $data = $request->all();
            $data['password'] = bcrypt($request->password);
            User::findOrFail($request->id)->update($data);
            return response()->json(['message' => 'User updated'], 200);
        } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (ValidationException $e) {
            return response()->json(['message' => $e->getMessage()], 409);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }


    public function delete(Request $request)
    {
        try {
            User::findOrFail($request->id)->delete();
            return response()->json(['message' => 'User deleted'], 200);
        } catch (QueryException $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        } catch (Exception $e) {
            return response()->json(['message' => 'An error occurred'], 500);
        }
    }
}
