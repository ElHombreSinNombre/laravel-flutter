<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Str;


class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        User::create([
            'id' => Str::uuid(),
            'name' => 'Admin',
            'email' => 'flutterlaravel@test.com',
            'password' => app('hash')->make('test'),
            'language' => 'es',
            'city' => 'Bilbao',
            'latitude' => '43.26271',
            'longitude' => '-2.92528',
        ]);

        User::factory()->count(9)->create();
    }
}