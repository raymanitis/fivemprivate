import React, { useState } from "react"
import { useNuiEvent } from "../hooks/useNuiEvent"

const MissionStatus: React.FC = () => {
    const [title, setTitle] = useState('')
    const [text, setText] = useState('')
    
    useNuiEvent<any>('missionStatus', (data) => {
        setTitle(data.title)
        setText(data.text)
    })

    return (
        <div
            style={{
                width: '100%',
                height: '100%',
                margin: -8, 
                position: 'fixed',
                display: 'flex',
                alignItems: 'flex-start',
                padding: '1rem',
                fontFamily: "'Bai Jamjuree', sans-serif",
                userSelect: 'none',
            }}
        >
            <div
                style={{
                    maxWidth: '400px',
                    display: 'flex',
                    flexDirection: 'column',
                    gap: '0.5rem',
                }}
            >
                {/* Title */}
                <div
                    style={{
                        color: '#C2F4F9',
                        fontSize: '1.25rem',
                        fontWeight: 600,
                    }}
                >
                    {title}
                </div>

                {/* Divider */}
                {title && (
                    <div
                        style={{
                            width: '100%',
                            height: '1px',
                            backgroundColor: 'rgba(194, 244, 249, 0.4)',
                            margin: '0.25rem 0',
                        }}
                    />
                )}

                {/* Content Box */}
                <div
                    style={{
                        backgroundColor: '#121a1cde',
                        border: '0.0625rem solid #c2f4f967',
                        borderRadius: '0.25rem',
                        padding: '0.75rem 1rem',
                        color: 'rgba(255, 255, 255, 0.9)',
                        fontSize: '0.9rem',
                        fontWeight: 400,
                        lineHeight: '1.5',
                    }}
                >
                    <style dangerouslySetInnerHTML={{
                        __html: `
                            .mission-content p {
                                margin: 0.5rem 0;
                            }
                            .mission-content p:first-child {
                                margin-top: 0;
                            }
                            .mission-content p:last-child {
                                margin-bottom: 0;
                            }
                            .mission-content strong {
                                color: #C2F4F9;
                                font-weight: 600;
                            }
                            .mission-content em {
                                color: rgba(194, 244, 249, 0.8);
                                font-style: italic;
                            }
                            .mission-content ul {
                                margin: 0.5rem 0;
                                padding-left: 1.5rem;
                            }
                            .mission-content li {
                                margin: 0.25rem 0;
                            }
                            .mission-content a {
                                color: #C2F4F9;
                                text-decoration: none;
                            }
                            .mission-content a:hover {
                                text-decoration: underline;
                            }
                        `
                    }} />
                    <div 
                        className="mission-content"
                        dangerouslySetInnerHTML={{ __html: text }}
                    />
                </div>
            </div>
        </div>
    )
}

export default MissionStatus
