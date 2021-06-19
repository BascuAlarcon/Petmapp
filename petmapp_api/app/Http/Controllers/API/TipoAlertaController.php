<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\TipoAlerta;
use Illuminate\Http\Request;

class TipoAlertaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return TipoAlerta::all();
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $tipo = new TipoAlerta();
        $tipo->tipo_alerta = $request->tipo_alerta ;
        $tipo->save();
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\TipoAlerta  $tipoAlerta
     * @return \Illuminate\Http\Response
     */
    public function show(TipoAlerta $tipoAlerta)
    {
        return $tipoAlerta;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\TipoAlerta  $tipoAlerta
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, TipoAlerta $tipoAlerta)
    {
        $tipoAlerta->tipo_alerta = $request->tipo_alerta;
        $tipoAlerta->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\TipoAlerta  $tipoAlerta
     * @return \Illuminate\Http\Response
     */
    public function destroy(TipoAlerta $tipoAlerta)
    {
        $tipoAlerta->delete();
    }
}
